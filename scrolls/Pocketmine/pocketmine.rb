class Pocketmine < Scroll
  def initialize(options = {}, name = 'Pocketmine')
    self.name = name
    self.type = 'Pocketmine'
    self.author = 'Dernise'
    self.version = 'Alpha_1.3.11'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.options = options
    super
  end

  def install #No time: hardcoding
    register('./start.sh')
    System.apt_get('update')
    System.apt_get('install', 'm4 automake autoconf make gcc libtool')
    copy(self.install_folder, 'installer.sh', './scrolls/Pocketmine')
    copy(self.install_folder, 'server.properties', './scrolls/Bukkit')
    replace_in_file('server.properties', '<!port>', self.options['port'])
    `cd #{self.install_folder} && ./installer.sh`
    UsersManager.add_user(self.name, options['password'], 'EdenManager', '/sbin/nologin', "/opt/EdenManager/EdenApps/#{self.type}/#{self.name}")
    options['username'] = self.name
    options['group'] = 'EdenManager'
    set_permissions
    update_status
  end

  def uninstall(id)
    user = $db.services.where(id: id).first
    `pkill -9 -u #{user[:username]}` #Kills the user
    UsersManager.delete_account(user[:username], true) #Delete his account
    `rm -R #{user[:folder_name]}` #Delete his home folder
    $db.services.where(id: id).delete #Delete it from database
  end
end