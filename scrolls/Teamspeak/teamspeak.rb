class Teamspeak < Scroll
  def initialize(options = {}, name = 'Teamspeak')
    self.name = name
    self.type = 'Teamspeak'
    self.author = 'Dernise'
    self.version = '3.0.10.1'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://dl.4players.de/ts/releases/3.0.10.1/teamspeak3-server_linux-x86-3.0.10.1.tar.gz'
    self.options = options
    super
  end

  def install
    register('sh ts3server_minimal_runscript.sh')
    download('teamspeak.tar.gz')
    copy(self.install_folder, 'teamspeak.tar.gz')
    Console.show `cd #{self.install_folder} && tar xvfz teamspeak.tar.gz`, 'debug'
    update_status
  end

  def uninstall(id) #TODO: Recode this. Really.
    self.install_folder = $db.services.where(id: id).first[:folder_name]
    puts `rm -R #{self.install_folder}`
    $db.services.where(id: id).delete
  end
end