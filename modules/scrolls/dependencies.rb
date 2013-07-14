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

  def install_dependencies
    @deps.each do |dep|
      Console.show "Installing dependency : #{dep}", 'info'
      dep_installer = ScrollInstaller.new(dep)
      dep_installer.install
    end
  end
end