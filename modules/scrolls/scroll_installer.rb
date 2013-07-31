class ScrollInstaller
  def initialize(s, options = {})
    @scroll = s
    @scroll_file = s.downcase
    @options=options
  end

  def get_scroll
    if File.exists?("./scrolls/#{@scroll}/#{@scroll_file}.rb")
      require "./scrolls/#{@scroll}/#{@scroll_file}"
      klass = Object.const_get(@scroll)
      raise InvalidScrollError if !klass.ancestors.include?(Scroll)
      klass
    else
      Console.show "Can't find the scroll #{@scroll}", 'error'
      raise UnknownScrollError
    end
  end

  def install
    begin
      scroll = get_scroll.new(@options)
      scroll.install_dependencies
      scroll.install
    rescue NoMethodError
      Console.show 'The scroll is invalid, a method is missing.', 'error'
    rescue AlreadyInstalledError
      Console.show "#{@scroll} is already installed", 'info'
    end
  end

  def install_dependency
    begin
      scroll = get_scroll.new(dependency: true)
      if scroll.dependable
        scroll.install_dependencies
        scroll.install
      end
    rescue AlreadyInstalledError
      Console.show "Dependency #{@scroll} is already installed", 'info'
    rescue NoMethodError
      Console.show 'The scroll is invalid, a method is missing.', 'error'
    end
  end
end
