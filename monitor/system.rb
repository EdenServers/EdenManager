# This file will contain all System calls by the program.
# (ie : Launching a programm, monitoring it)

# Returns the pid of the child that executes the cmd
module Monitoring
  module System

    def daemonize(cmd, options = {})
      rd, wr = IO.pipe
      if child = Daemonize.safefork
        # parent
        ::Process.detach(child)
        wr.close

        daemon_id = rd.read.to_i
        rd.close

        return daemon_id if daemon_id > 0

      else
        # child
        rd.close
        set_user(options[:utilisateur]) if !options[:utilisateur].nil?

        # if we cannot write the pid file as the provided user, err out
        #exit unless can_write_pid_file(options[:pid_file], options[:logger])

        to_daemonize = lambda do
          # Setting up the
          Dir.chdir(ENV['PWD'] = options[:working_dir].to_s) if options[:working_dir]
          #redirect_io(*options.values_at(:stdin, :stdout, :stderr))

          ::Kernel.exec(*Shellwords.shellwords(cmd))
          exit
        end

        daemon_id = Daemonize.call_as_daemon(to_daemonize, nil, cmd)

        File.open(options[:pid_file], 'w') {|f| f.write(daemon_id)}

        wr.write daemon_id
        wr.close

        exit
      end
    end

    #Launch the program as a specific User.
    def set_user(uid)
      if ::Process::Sys.geteuid == 0
        uid_num = Etc.getpwnam(uid).uid if uid
        ::Process::Sys.setuid(uid_num) if uid
      end
    end

    def create_unix_user(name, password)

    end
  end
end
