class Bukkit < Scroll
  def initialize(options = {}, name = 'Bukkit')
    self.name = name
    self.type = 'Bukkit'
    self.author = 'Dernise'
    self.version = '2788'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://dl.bukkit.org/downloads/craftbukkit/get/02381_1.6.4-R1.0/craftbukkit.jar'
    self.options = options
    super
  end

  def set_dependencies
    add_dep('Java')
  end

  def install
    register("java -jar -Xms250M -Xmx#{self.options['ram']}M craftbukkit.jar")
    download('craftbukkit.jar')
    copy(self.install_folder, 'craftbukkit.jar')
    copy(self.install_folder, 'server.properties', './scrolls/Bukkit')
    copy(self.install_folder + "/plugins/JSONAPI", 'config.yml', './scrolls/Bukkit')
    copy(self.install_folder + "/plugins/JSONAPI", 'users.yml', './scrolls/Bukkit')
    copy(self.install_folder + "/plugins/", 'JSONAPI.jar', './scrolls/Bukkit')
    replace_in_file('server.properties', '<!port>', self.options['port'])
    replace_in_file('server.properties', '<!motd>', self.options['motd'])
    replace_in_file('plugins/JSONAPI/config.yml', '<!port>', (self.options['port'].to_i + 1).to_s)
    set_permissions
    install_controller('Bukkit')
    update_status
  end

  def uninstall(id)
    self.install_folder = $db.services.where(id: id).first[:folder_name]
    ServiceManager.stop_service(id)
    puts `rm -R #{self.install_folder}`
    $db.services.where(id: id).delete
  end
end