class ServiceManager
  def initialize
    @services = new Array
  end

  def close_service(service)
    @services.each do |s|
      if s.name == service
        s.kill
        @services.delete(s)
      end
    end
  end

  def start_service(service)

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