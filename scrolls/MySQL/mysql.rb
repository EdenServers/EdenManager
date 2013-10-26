class MySQL < Scroll
  def initialize(options = {})
    self.name = 'MySQL'
    self.author = 'Koon'
    self.version = '5.4'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = true
    super
  end

  def install
    System.apt_get('update')
    System.apt_get('install', 'mysql-server')
    register('/etc/init.d/mysql restart')
  end
end