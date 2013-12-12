module ControllersManager
  @controllers_list = Array.new

  def self.new
    load_controllers
  end

  def self.get_controller_class(name)
    if File.exists?("./modules/controllers/#{name}Controller.rb")
      require "./modules/controllers/#{name}Controller"
      klass = Object.const_get("#{name}Controller")
      raise ControllerInvalidError if !klass.ancestors.include?(Controller)
      klass
    else
      Console.show "Can't find the controller #{@scroll}", 'error'
      raise ControllerInvalidError
    end
  end

  def self.load_controllers #load all the controllers
    begin
      $db.controller_lists.all.each do |controller|
        @controllers_list << get_controller_class(controller[:controller_name]).new
        Console.show "Loaded controller : #{controller[:controller_name]}", 'debug'
      end
      Console.show 'All controllers are now loaded', 'info'
    rescue ControllerInvalidError => e
      Console.show "#{e}", 'ERROR'
    end
  end

  def self.load_controller(name) #load a single controller
    begin
      @controllers_list << get_controller_class(name).new
    rescue ControllerInvalidError => e
      Console.show "#{e}", 'ERROR'
    end
  end

  def self.get_controller(name)
    @controllers_list.each do |controller|
      if controller.controller_type == name
        return controller
      end
    end
  end
end