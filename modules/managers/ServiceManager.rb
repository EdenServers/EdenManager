class ServiceManager
  def initialize
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
        service = Monitoring::Service.new(serviceId)
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
end