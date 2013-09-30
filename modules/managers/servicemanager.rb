module ServiceManager
  def new
    @started_services = Array.new
  end

  #Kill the service (require its id)
  def close_service(service)
    @started_services.each do |s|
      if s.id == service
        s.kill
        @started_services.delete(s)
      end
    end
  end

  #return the last 50 lines of the console
  def get_console(service)
    @started_services.each do |s|
      if s.id == service
        s.get_console
      end
    end
  end

  #return the cpu usage of the service
  def get_cpu_usage(service)
    @started_services.each do |s|
      if s.id == service
        return s.cpu_usage
      end
    end
    'Offline' #If the service is offline
  end

  #return the ram usage of the service
  def get_ram_usage(service)
    @started_services.each do |s|
      if s.id == service
        return s.cpu_usage
      end
    end
  end

  #start the service
  def start_service(serviceId)
    unless service_started?(serviceId)
      Thread.new {
        service = ServiceSystem::Service.new(serviceId)
        service.start_service
        $started_services << service
      }
    end
  end

  #is service started?
  def service_started? (service)
      @started_services.each do |s|
      if s.id == service
        return true
      end
    end
    false
  end

  #delete the service from the array. Should only be used if the service is already dead
  def remove_service(service)
    @started_services.each do |s|
      if s.id == service
        @started_services.delete(s)
      end
    end
  end

  #send a command to the process' stdin
  def send_command(serviceId, command)
    @started_services.each do |s|
      if s.id == serviceId
        s.execute(command)
      end
    end
  end

  #Update the service
  def update(serviceId)
    $db.services.each do |service|
      if service[:id] == serviceId
        updater = ScrollInstaller.new(service[:serviceType])
        updater.update(service)
      end
    end
  end
end