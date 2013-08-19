module ServiceManager
  def init
    @services = Array.new
  end

  def close_service(service)
    @services.each do |s|
      if s.id == service
        s.kill
        @services.delete(s)
      end
    end
  end

  def get_console(service)
    @services.each do |s|
      if s.id == service
        puts s.stdout_err
      end
    end
  end

  def get_cpu_usage(service)
    @services.each do |s|
      if s.id == service
        return s.cpu_usage
      end
    end
  end

  def get_ram_usage(service)
    @services.each do |s|
      if s.id == service
        return s.cpu_usage
      end
    end
  end

  def start_service(serviceId)
    unless service_started?(serviceId)
      Thread.new {
        service = ServiceSystem::Service.new(serviceId)
        service.start_service
        @services << service
      }
    end
  end

  def service_started? (service)
     @services.each do |s|
      if s.id == service
        return true
      end
    end
    false
  end

  def remove_service(service)
    @services.each do |s|
      if s.id == service
        @services.delete(s)
      end
    end
  end

  def send_command(serviceId, command)
    @services.each do |s|
      if s.id == serviceId
        s.execute(command)
      end
    end
  end

  def update(serviceId)
    $db.services.each do |service|
      if service[:id] == serviceId
        updater = ScrollInstaller.new(service[:serviceType])
        updater.update(service)
      end
    end
  end
end
include ServiceManager