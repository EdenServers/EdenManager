class ScrollInstaller
  def initialize(s)
    @scroll = s
    @scroll_file = s.downcase
  end

  def get_scroll
    if File.exists?("./scrolls/#{@scroll_file}.rb".downcase)
      require "./scrolls/#{@scroll_file}"
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
        scroll.install_dependencies
        scroll.install
      rescue NoMethodError
        Console.show 'The scroll is invalid, a method is missing.', 'error'
      end
    else
      Console.show 'This scroll doesn\'t include the scroll Object', 'error'
    end
  end
end
