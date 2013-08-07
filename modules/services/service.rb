module Monitoring
  class Service
    attr_accessor :id, :type, :name, :daemon_id, :alive, :monitoring, :cpu_usage, :ram_usage

    def initialize(id)
      if @service = is_service_installed?(id)
        #default properties
        self.id=id
        self.monitoring = true
        self.cpu_usage=0
        self.ram_usage=0
        self.name=@service[:serviceName]
        self.type=@service[:serviceType]
      else
        raise ScrollNotInstalledError
      end
    end

    #Start the program
    def start_service
      @daemon_id = get_pid(@service[:pidFile])
      if !process_alive?
        @daemon_id = System.daemonize(@service[:startCommand], {working_dir: @service[:folderName], pid_file: @service[:pidFile]})
        Console.show "Process started, its id is : #{@daemon_id}", 'info'
      else
        Console.show "Process is already running, its id is : #{@daemon_id}", 'info'
      end
      start_monitoring if monitoring
    end

    def start_monitoring
      if @monitor_timer.nil?
        @monitor = Monitor.new
        @monitor_timer=$scheduler.every '5s' do
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
        @cpu_usage = @monitor.cpu_usage(@daemon_id, true)
        @ram_usage = @monitor.memory_usage(@daemon_id, true)
        Console.show "Currently, the program #{@daemon_id} use #{@ram_usage}MB of memory and #{@cpu_usage}% of CPU", 'info'
        #Todo : send an update to the api
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

    def is_service_installed?(id)
      $db.services.each do |service|
        if service[:id] == id
          return service
        end
      end
      false
    end
  end
end
