class Steamcmd < Scroll
  def initialize(options = {}, name = 'Steamcmd')
    self.name = name
    self.type = 'Steamcmd'
    self.author = 'Dernise'
    self.version = '1'
    self.dependable = true
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://media.steampowered.com/installer/steamcmd_linux.tar.gz'
    self.options = options
    super
  end

  def install #No time: hardcoding
    register('sh ts3server_minimal_runscript.sh')
    `dpkg --add-architecture i386`
    System.apt_get('update')
    System.apt_get('install', 'ia32-libs')
    download('steamcmd.tar.gz')
    copy(self.install_folder, 'steamcmd.tar.gz')
    Console.show  `cd #{self.install_folder} && tar xvfz steamcmd.tar.gz`, 'info'
    set_permissions
    install_controller('Steamcmd')
    update_status
  end

  def uninstall(id) #TODO: Recode this. Really.
    self.install_folder = $db.services.where(id: id).first[:folder_name]
    puts `rm -R #{self.install_folder}`
    $db.services.where(id: id).delete
  end
end