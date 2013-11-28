class Spigot < Scroll
  def initialize(options = {})
    self.name = 'Spigot'
    self.author = 'SofianeG'
    self.version = '1120'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://ci.md-5.net/job/Spigot/lastStableBuild/artifact/Spigot-Server/target/spigot.jar'
    self.options = options
    super
  end

  def set_dependencies
    add_dep('Java')
  end

  def install
    download('spigot.jar')
    copy(self.install_folder, 'spigot.jar')
    copy(self.install_folder, 'server.properties', './scrolls/Spigot')
    register("java -jar -Xms250M -Xmx#{self.options['ram']}M spigot.jar")
  end
end