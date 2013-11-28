class Tekkit < Scroll
  def initialize(options = {})
    self.name = 'Tekkit'
    self.author = 'SofianeG'
    self.version = '1.1.8'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://mirror.technicpack.net/Technic/servers/tekkitmain/Tekkit_Server_v1.1.8.zip'
    self.options = options
    super
  end

  def set_dependencies
    add_dep('Java')
  end

  def install
    download('Tekkit_Server_v1.1.8.zip')
    copy(self.install_folder, 'Tekkit_Server_v1.1.8.zip')
    extract('zip','Tekkit_Server_v1.1.8.zip',self.install_folder)
    # Fonction de suppression ?
    copy(self.install_folder, 'server.properties', './scrolls/Tekkit')
    register("java -jar -Xms250M -Xmx#{self.options['ram']}M Tekkit.jar")
  end
end