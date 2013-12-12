class ScrollInstaller
  def initialize(s, name = '', options = {})
    @scroll = s
    @scroll_file = s.downcase if s.class != Fixnum
    @service_name = name
    @options=options
  end

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

  def uninstall
    service_id = @scroll
    @scroll = $db.services.where(id: service_id).first[:service_type]
    @scroll_file = @scroll.downcase
    scroll = get_scroll.new
    scroll.uninstall(service_id)
    'SUCCESS'
  end

  def install
    begin
      scroll = get_scroll.new(@options, @service_name)
      scroll.install_dependencies
      scroll.install #This will return the installed service's id.
      'SUCCESS'
    rescue NoMethodError => e
      Console.show 'The scroll is invalid, a method is missing.', 'error'
      Console.show e, 'error'
      'INVALID'
    rescue ScrollInstallError => e
      Console.show "#{@scroll} had a problem with the installation, abording.", 'error'
      Console.show e, 'error'
      'ERROR'
    rescue StandardError => e
      Console.show "#{@scroll} had a problem with the installation, abording.", 'error'
      Console.show e, 'error'
      'ERROR'
    end
  end

  def install_dependency
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

  def update(service)
    begin
      scroll = get_scroll.new
      scroll.update(service)
    rescue AlreadyInstalledError
      Console.show "Dependency #{@scroll} is already installed", 'info'
    rescue NoMethodError
      Console.show 'The scroll is invalid, a method is missing.', 'error'
    end
  end
end
