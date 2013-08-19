#Contains system calls for the monitor
module ServiceSystem
  module System
    def daemonize(cmd, service, options = {})
      child_socket, parent_socket = Socket.pair(:UNIX, :DGRAM, 0) # used to send message to the process
      rd, wr = IO.pipe # used to send the pid
      p1 = Process.fork { #start a new process by forking the parent
        threads = []
        Dir.chdir(ENV["PWD"] = options[:working_dir].to_s) if options[:working_dir] #teleport to the install folder
        stdin, stdout, stderr, wait_thr = Open3.popen3(*Shellwords.shellwords(cmd))
        parent_socket.close
        rd.close
        wr.write wait_thr[:pid]
        wr.close
        handle_input(stdin, wait_thr, child_socket, threads) #handle app's stdin
        handle_output(stdout, stderr, service, wait_thr, threads) #handle app's stdout/stderr
        threads.map(&:join)
        exit
      }
      Process.detach(p1) # divorce p1 from parent process (shell)
      child_socket.close
      wr.close
      daemon_id = rd.read.to_i
      rd.close
      pidfile = File.new(options[:pid_file], 'w')
      pidfile.chmod( 0644 )
      pidfile.puts "#{daemon_id}"
      pidfile.close
      service.stdin = parent_socket
      daemon_id
    end

    def handle_input(stdin, wait_thr, child_socket, threads)
      threads << Thread.new {
        while wait_thr.status
          if child_socket.ready?
            stdin.write(child_socket.recv(1024))
          end
          sleep 1
        end
      }
    end

    def handle_output (stdout,stderr,service,wait_thr,threads)
      threads << Thread.new {  #handle stdout
        while wait_thr.status
          if stdout.ready?
            service.stdout_err.shift
            service.stdout_err << stdout.gets
          end
          sleep 1
        end
      }

      threads << Thread.new { #handle stderr
        while wait_thr.status
          if stderr.ready?
            service.stdout_err.shift
            service.stdout_err << stderr.gets
          end
          sleep 1
        end
      }
    end

    #Launch the program as a specific User.
    def set_user(uid)
      if ::Process::Sys.geteuid == 0
        uid_num = Etc.getpwnam(uid).uid if uid
        ::Process::Sys.setuid(uid_num) if uid
      end
    end
  end
end
