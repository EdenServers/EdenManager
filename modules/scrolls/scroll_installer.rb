class ScrollInstaller
  def initialize(s)
    @scroll = s
  end

  def get_scroll
    if File.exists?("./scrolls/#{@scroll}.rb".downcase)
      Console.show "Running the scroll #{@scroll}", 'info'
      require "./scrolls/#{@scroll}".downcase
      klass = Object.const_get(@scroll)
      return false if !klass.ancestors.include?(Scroll)
      klass
    else
      Console.show "Can't find the scroll #{@scroll}", 'error'
      false
    end
  end

  def install
    s = get_scroll
    if s
      scroll = s.new
      begin
        scroll.install
      rescue NoMethodError
        Console.show 'The scroll is invalid, a method is missing.', 'error'
      end
    end
  end
end
