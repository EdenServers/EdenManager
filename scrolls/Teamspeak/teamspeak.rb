class Teamspeak < Scroll
  def initialize(options = {}, name = 'Teamspeak')
    self.name = name
    self.type = 'Teamspeak'
    self.author = 'Dernise'
    self.version = '3.0.10.1'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://dl.4players.de/ts/releases/3.0.10.1/teamspeak3-server_linux-amd64-3.0.10.1.tar.gz'
    self.options = options
    super
  end

  def install #No time: hardcoding
    register('sh ts3server_minimal_runscript.sh')
    download('teamspeak.tar.gz')
    Console.show `cd ./downloads && tar xvfz teamspeak.tar.gz`, 'debug'
    Console.show  `cp -R teamspeak3-server_linux-amd64/* #{self.install_folder}`, 'info'
    update_status
  end

  def uninstall(id) #TODO: Recode this. Really.
    self.install_folder = $db.services.where(id: id).first[:folder_name]
    puts `rm -R #{self.install_folder}`
    $db.services.where(id: id).delete
  end
end