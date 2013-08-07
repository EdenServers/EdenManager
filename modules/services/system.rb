#Contains system calls for the monitor
module Monitoring
  module System
    def daemonize(cmd, options = {})
      rd, wr = IO.pipe
      p1 = Process.fork {
        Process.setsid
        p2 = Process.fork {
          $0 =  cmd #Name of the command
          pidfile = File.new(options[:pid_file], 'w')
          pidfile.chmod( 0644 )
          pidfile.puts "#{Process.pid}"
          pidfile.close
          Dir.chdir(ENV["PWD"] = options[:working_dir].to_s) if options[:working_dir]
          File.umask 0000
          STDIN.reopen '/dev/null'
          STDOUT.reopen '/dev/null', 'a'
          STDERR.reopen STDOUT
          Signal.trap("USR1") do
            Console.show 'I just received a USR1', 'warning'
          end
          ::Kernel.exec(*Shellwords.shellwords(cmd)) #Executing the command in the parent process
          exit
        }
        raise 'Fork failed!' if p2 == -1
        Process.detach(p2) # divorce p2 from parent process (p1)
        rd.close
        wr.write p2
        wr.close
        exit
      }
      raise 'Fork failed!' if p1 == -1
      Process.detach(p1) # divorce p1 from parent process (shell)
      wr.close
      daemon_id = rd.read.to_i
      rd.close
      daemon_id
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
