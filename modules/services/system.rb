#Contains system calls for the monitor
module ServiceSystem
  module System
    def daemonize(cmd, service,options = {})
      stdin_r, stdin_wr = IO.pipe
      rd, wr = IO.pipe
      service.stdin = stdin_wr
      p1 = Process.fork {
        Dir.chdir(ENV["PWD"] =
        options[:working_dir].to_s) if options[:working_dir]
        stdin, stdout, stderr, wait_thr = Open3.popen3(*Shellwords.shellwords(cmd))
        rd.close
        wr.write wait_thr[:pid]
        wr.close
        stdin.reopen stdin_r
        handle_output(stdout, stderr, wait_thr)
        exit
      }
      Process.detach(p1) # divorce p1 from parent process (shell)
      stdin_r.close
      stdin_wr.write ('list\n')
      wr.close
      daemon_id = rd.read.to_i
      rd.close
      pidfile = File.new(options[:pid_file], 'w')
      pidfile.chmod( 0644 )
      pidfile.puts "#{daemon_id}"
      pidfile.close
      daemon_id
    end

    def handle_output (stdout,stderr,wait_thr)
      threads = []
      threads << Thread.new {  #handle stdout
        while wait_thr.status
          if stdout.ready?
            puts stdout.gets
          end
          sleep 1
        end
      }

      threads << Thread.new { #handle stderr
        while wait_thr.status
          if stderr.ready?
            puts stderr.gets
          end
          sleep 1
        end
      }
      threads.map(&:join)
    end

    #Launch the program as a specific User.
    def set_user(uid)
      if ::Process::Sys.geteuid == 0
        uid_num = Etc.getpwnam(uid).uid if uid
        ::Process::Sys.setuid(uid_num) if uid
      end
    end

    def redirect_io
      unless File.exist? './EdenLogs'
        FileUtils.mkdir 'EdenLogs'
      end
      $stdin.reopen './EdenLogs/stdout.log'
      $stdout.reopen './EdenLogs/stdout.log', 'a'
      $stderr.reopen './EdenLogs/stderr.log', 'a'
    end
  end
end
