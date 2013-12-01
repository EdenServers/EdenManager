module ServiceManager
  def self.new
    @started_services = Array.new
  end

  #Kill the service (require its id)
  def self.stop_service(service)
    @started_services.each do |s|
      if s.id == service
        s.kill
        @started_services.delete(s)
        $db.services.where(:id=>s.id).update(:running => 0)
      end
    end
  end

  #return the last 50 lines of the console
  def self.get_console(service)
    @started_services.each do |s|
      if s.id == service
        s.get_console
      end
    end
  end

  #return the cpu usage of the service
  def self.get_cpu_usage(service)
    @started_services.each do |s|
      if s.id.to_i == service
        return s.get_cpu_usage
      end
    end
    'Offline' #If the service is offline
  end

  #Return the list of installed services
  def self.get_installed_services
    installed_services = Array.new
    $db.services.each do |s|
      installed_services.push({id: s[:id], start_command: s[:start_command], service_name: s[:service_name], service_type: s[:service_type], dependency: s[:dependency], running: s[:running],version: s[:version]})
    end
    installed_services
  end

  #return the ram usage of the service
  def self.get_ram_usage(service)
    @started_services.each do |s|
      if s.id.to_i == service
        return s.get_ram_usage
      end
    end
    'Offline' #If the service is offline
  end

  #start the service
  def self.start_service(serviceId)
    unless service_started?(serviceId)
      Console.show "Starting process: #{serviceId}", 'info'
      service = ServiceSystem::Service.new(serviceId)
      service.start_service
      @started_services << service
      $db.services.where(:id=>Integer(serviceId)).update(:running => 1)
    else
      Console.show "Service #{serviceId} is already running", 'info'
    end
  end

  #is service started?
  def self.service_started?(service)
    @started_services.each do |s|
      if s.id == service
        return true
      end
    end
    false
  end

  #delete the service from the array. Should only be used if the service is already dead
  def self.remove_service(service)
    @started_services.each do |s|
      if s.id == service
        @started_services.delete(s)
        $db.services.where(:id=>s.id).update(:running => 0)
      end
    end
  end

  #send a command to the process' stdin
  def self.send_command(serviceId, command)
    @started_services.each do |s|
      if s.id == serviceId
        s.execute(command)
      end
    end
  end

  #Update the service
  def self.update(serviceId)
    $db.services.each do |service|
      if service[:id] == serviceId
        updater = ScrollInstaller.new(service[:serviceType])
        updater.update(service)
      end
    end
  end
end