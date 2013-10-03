module ServiceSystem
  class Service
    attr_accessor :id, :type, :name, :daemon_id, :alive, :monitoring, :cpu_usage, :ram_usage, :socket, :stdout_err

    def initialize(id)
      if @service = is_service_installed?(id)
        #default properties
        self.id=id
        self.monitoring = true
        self.cpu_usage=0
        self.ram_usage=0
        self.name=@service[:service_name]
        self.type=@service[:service_type]
        self.stdout_err=Array.new(50)
      else
        raise ServiceNotInstalledError
      end
    end

    #Start the program
    def start_service
      @daemon_id = get_pid(@service[:pid_file])
      if !process_alive?
        @daemon_id = System.daemonize(@service[:start_command], self, start_options)
        Console.show "Process started, its id is : #{@daemon_id}", 'info'
      else
        Console.show "Process is already running, its id is : #{@daemon_id}", 'info'
      end
      start_monitoring if monitoring
    end

    def start_monitoring
      if @monitor_timer.nil?
        @monitor = Monitor.new
        @monitor_timer=$scheduler.every '1m' do
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
        get_cpu_usage
        get_ram_usage
        $db.monitor_services.insert(:cpu_usage => self.cpu_usage, :ram_usage => self.ram_usage, :service_id => self.id, :date => DateTime.now)
        @monitor.reset_ps_axu
      else
        Console.show "Process #{@daemon_id} has been killed", 'info'
        ServiceManager.remove_service(self.id)
        @monitor_timer.pause()
      end
    end

    #Kill the process
    def kill
      ::Process.kill('TERM', @daemon_id)
    end

    def get_cpu_usage
      @monitor.reset_ps_axu
      @cpu_usage = @monitor.cpu_usage(@daemon_id, true)
    end

    def get_ram_usage
      @monitor.reset_ps_axu
      @ram_usage = @monitor.ram_usage(@daemon_id, true)
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

    def start_options
      {
          working_dir: @service[:folder_name],
          pid_file: @service[:pid_file]
      }
    end

    def is_service_installed?(id)
      $db.services.each do |service|
        if service[:id] == id
          return service
        end
      end
      false
    end

    def execute(cmd)
      self.socket.send([cmd.length, 1].pack('LL') + cmd, 0)
    end

    def get_console
      self.socket.send([0, 2].pack('LL'))
    end
  end
end
