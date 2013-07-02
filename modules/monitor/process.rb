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
      if !process_alive?
        @daemon_id = System.daemonize(start_command, {working_dir: working_dir, pid_file: pid_file})
        Console.show "Process started, its id is : #{@daemon_id}", 'info'
      else
        Console.show "Process is already running, its id is : #{@daemon_id}", 'info'
      end
      start_monitoring if monitoring
    end

    def start_monitoring
      if @monitor_timer.nil?
        @monitor = Monitor.new
        @monitor_timer=$scheduler.every '1s' do
          tick
        end
      else
        if @monitor_timer.paused?
          @monitor_timer.resume
        end
      end
    end

    #Check the status of the program and monitor it
    def tick
      if process_alive?
        Console.show "Process #{@daemon_id} is still alive", 'info'
        Console.show "Currently, the program #{@daemon_id} use #{@monitor.memory_usage(@daemon_id, true)}MB of memory and #{@monitor.cpu_usage(@daemon_id, true)}% of CPU", 'info'
        @monitor.reset_ps_axu
      else
        Console.show "Process #{@daemon_id} has been killed", 'info'
        @monitor_timer.pause()
      end
    end

    #Kill the process
    def kill
      ::Process.kill('TERM', @daemon_id)
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
