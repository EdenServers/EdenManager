class ScrollInstaller
  def get_scroll
    if File.exists?("./scrolls/#{@scroll}/#{@scroll_file}.rb")
      require "./scrolls/#{@scroll}/#{@scroll_file}"
      klass = Object.const_get(@scroll)
      raise ScrollInvalidError if !klass.ancestors.include?(Scroll)
      klass
    else
      Console.show "Can't find the scroll #{@scroll}", 'error'
      raise ScrollInvalidError
    end
  end

  def uninstall(service_id)
    service = $db.services.where(id: service_id).first
    unless service.nil?
      @scroll = service[:service_type]
      @scroll_file = @scroll.downcase
      scroll = get_scroll.new
      scroll.uninstall(service_id)
      'SUCCESS'
    end
  end

  def install(s, name = '', options = {})
    begin
      @scroll = s
      @scroll_file = s.downcase
      scroll = get_scroll.new(options, name)
      scroll.install_dependencies
      scroll.install #This will return the installed service's id.
    rescue NoMethodError => e
      Console.show 'The scroll is invalid, a method is missing.', 'error'
      Console.show e, 'error'
    rescue ScrollInstallError => e
      Console.show "#{@scroll} had a problem with the installation, abording.", 'error'
      Console.show e, 'error'
    rescue StandardError => e
      Console.show "#{@scroll} had a problem with the installation, abording.", 'error'
      Console.show e, 'error'
    end
  end

  def install_dependency(dependency_name)
    @scroll = dependency_name
    @scroll_file = dependency_name.downcase
    begin
      scroll = get_scroll.new
      if scroll.dependable
        scroll.install_dependencies
        scroll.install
      end
    rescue DepAlreadyInstalledError
      Console.show "Dependency #{@scroll} is already installed", 'info'
    rescue NoMethodError => e
      Console.show 'The scroll is invalid, a method is missing.', 'error'
      Console.show e, 'error'
    rescue ScrollInstallError => e
      Console.show "#{@scroll} had a problem with the installation, abording.", 'error'
      Console.show e, 'error'
    rescue StandardError => e
      Console.show "#{@scroll} had a problem with the installation, abording.", 'error'
      Console.show e, 'error'
    end
  end
end
