module Monitoring
  class Process
    CONFIGURABLE_ATTRIBUTES = [
      :start_command,
      :daemonize,
    ]

    attr_accessor :start_command, :daemonize, :name, :working_dir, :pid_file, :daemon_id

    def initialize(name, start_command)
      self.name=name
      self.start_command=start_command
      start_process()
    end

    def start_process
      @daemon_id = System.daemonize(start_command, {working_dir: '/Users/dernise/minecraft', pid_file: '/Users/dernise/test.pid'})
      Console.show( "Process started, process id is : #{@daemon_id}", 'info')
      if !process_alive?
        Console.show('Process is not working', 'error')
      end
    end

    def daemonized?
      self.daemonize
    end

    def process_alive?
      begin
        ::Process.getpgid(@daemon_id)
        true
      rescue Errno::ESRCH
        false
      end
    end
  end
end
