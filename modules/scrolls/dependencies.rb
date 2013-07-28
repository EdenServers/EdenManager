class Dependencies
  def initialize
    @deps=Array.new
  end

  def add_dependency(dep)
    @deps << dep
  end

  def remove_dependency(dep)
    @deps.delete(dep)
  end

  def get_dependencies
    @deps
  end

  def install_dependencies
    @deps.each do |dep|
      begin
        Console.show "Installing dependency : #{dep}", 'info'
        installer = ScrollInstaller.new(dep)
        installer.install_dependency
      rescue
        #TODO : Report it on the panel
        Console.show "Could not install dependency #{dep}", 'error'
        raise InstallScrollError
      end
    end
  end
end