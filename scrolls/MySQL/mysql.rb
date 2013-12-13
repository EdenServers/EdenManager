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
    mysql_password = SecureRandom.hex(5)
    Console.show `export DEBIAN_FRONTEND=noninteractive && apt-get -q -y install mysql-server`, 'debug'
    Console.show `mysqladmin -u root password #{mysql_password}`, 'debug'
    Configuration.set_config_opt('mysql_password', mysql_password)
    Console.show 'Mysql password is : ' + mysql_password, 'info'
  end
end