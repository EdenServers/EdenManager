class MySQL < Scroll
  def initialize(name = 'MySQL',options = {})
    self.name = name
    self.type = 'MySQL'
    self.author = 'Koon'
    self.version = '5.5'
    self.dependable = true
    self.homepage = 'http://wwww.edenservers.fr'
    self.options = options
    super
  end

  def install
    System.command("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password #{option['password']}'")
    System.command("debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password #{option['password']}'")
    System.apt_get('install', 'mysql-server')
    register("/etc/init.d/mysql restart")
  end
end