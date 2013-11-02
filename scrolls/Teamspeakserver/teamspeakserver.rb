class TSSERVER < Scroll
  def initialize(name = 'TeamSpeak Server', options = {})
    self.name = name
    self.type = 'TeamSpeak 3 Server'
    self.author = 'SofianeG'
    self.version = '3.0.10'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://dl.4players.de/ts/releases/3.0.10/teamspeak3-server_linux-amd64-3.0.10.tar.gz'
    self.dependable = false
    super
  end

  def install
    download('teamspeak3-server_linux-amd64-3.0.10.tar.gz')
    copy(self.install_folder, 'teamspeak3-server_linux-amd64-3.0.10.tar.gz')
    tar -zxvf #{'teamspeak3-server_linux-amd64-3.0.10.tar.gz'}`
    register ('ts3server_startscript.sh restart')
  end
end