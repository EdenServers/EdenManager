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
      Console.show "Installing dependency : #{dep}", 'info'
      installer = ScrollInstaller.new
      installer.install_dependency(dep)
    end
  end
end