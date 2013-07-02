module Monitoring
  class Process
    attr_accessor :start_command, :name, :working_dir, :pid_file, :daemon_id, :alive, :monitoring

    def initialize(name, start_command)
      #default properties
      self.name=name
      self.start_command=start_command
      self.monitoring = true
    end

    #Start the program
    def start_process
      @daemon_id = get_pid(pid_file)
      puts(@daemon_id)
      if !process_alive?
        @daemon_id = System.daemonize(start_command, {working_dir: working_dir, pid_file: pid_file})
        Console.show "Process started, its id is : #{@daemon_id}", 'info'
      else
        Console.show "Process is already running, its id is : #{@daemon_id}", 'info'
      end
      start_monitoring if monitoring
    end

    def start_monitoring
      if @monitor.nil?
        @monitor=$scheduler.every '5s' do
          tick
        end
      else
        if @monitor.paused?
          @monitor.resume
        end
      end
    end

    #Check the status of the program and monitor it
    def tick
      if process_alive?
        Console.show "Process #{@daemon_id} is still alive", 'info'
      else
        Console.show "Process #{@daemon_id} has been killed", 'info'
        @monitor.pause()
      end
    end

    def get_pid(pid_file)
      begin
        file = File.open(pid_file)
        pid = file.readline
        Integer(pid)
      rescue Errno::ENOENT #The file doesn't exist
        return
      end
    end

    def process_alive?
      begin
        ::Process.getpgid(@daemon_id)
        @alive = true
        true
      rescue Errno::ESRCH
        @alive = false
        false
      rescue TypeError
        @alive = false
        false
      end
    end

    def get_name?
      self.name
    end
  end
end
