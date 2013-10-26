class PHP < Scroll
  def initialize(options = {})
    self.name = 'PHP'
    self.author = 'SofianeG'
    self.version = '5.5'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = true
    super
  end

  def set_dependencies
    add_dep('Apache')
    add_dep('MySQL')
  end

  def install
    add_source('deb http://packages.dotdeb.org wheezy-php55 all')
    add_source('deb-src http://packages.dotdeb.org wheezy-php55 all')
    System.apt_get('update')
    System.apt_get('install', 'libapache2-mod-php5')
    System.apt_get('install', 'php5-mysql')
    register('/etc/init.d/apache2 restart')
  end
end