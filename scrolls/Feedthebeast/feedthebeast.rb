class FeedTheBeast < Scroll
  def initialize(options = {})
    self.name = 'FeedTheBeast'
    self.author = 'SofianeG'
    self.version = 'Ultimate'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://www.creeperrepo.net/direct/FTB2/c10bbab2591b41b8f2949d7b3477387c/modpacks%5EUltimate%5E1_1_2%5EUltimate_Server.zip'
    self.options = options
    super
  end

  def set_dependencies
    add_dep('Java')
  end

  def install
    download('Ultimate_Server.zip')
    copy(self.install_folder, 'Ultimate_Server.zip')
    extract('zip','Ultimate_Server.zip',self.install_folder)
    # Fonction de suppression ?
    copy(self.install_folder, 'server.properties', './scrolls/Feedthebeast')
    register("java -jar -Xms250M -Xmx#{self.options['ram']}M ftbserver.jar")
  end
end