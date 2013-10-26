class PhpMyAdmin < Scroll
  def initialize(options = {})
    self.name = 'PhpMyAdmin'
    self.author = 'Koon'
    self.version = '5.4'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = false
    super
  end

  def set_dependencies
    add_dep('PHP')
  end

  def install
    System.apt_get('update')
    System.apt_get('install', 'phpmyadmin')
    register('/etc/init.d/apache2 restart')
  end
end