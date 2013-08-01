class ServiceManager
  def initialize
    @services = Array.new
  end

  def close_service(service)
    @services.each do |s|
      if s.name == service
        s.kill
        @services.delete(s)
      end
    end
  end

  def get_cpu_usage(service)
    @services.each do |s|
      if s.name == service
        return s.cpu_usage
      end
    end
  end

  def get_ram_usage(service)
    @services.each do |s|
      if s.name == service
        return s.cpu_usage
      end
    end
  end

  def start_service(serviceName)
    unless service_started?(serviceName)
      Thread.new {
        service = Monitoring::Service.new(serviceName)
        service.start_service
        @services << service
      }
    end
  end

  def service_started? (service)
    @services.each do |s|
      if s.name == service
        return true
      end
    end
    false
  end
end