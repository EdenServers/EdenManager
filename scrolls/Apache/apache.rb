class Apache < Scroll
  def initialize(name = 'Apache', options = {})
    self.name = name
    self.type = 'Apache'
    self.author = 'SofianeG'
    self.version = '2.4'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = true
    super
  end

  def install
    System.apt_get('update')
    System.apt_get('install', 'apache2')
    register('/etc/init.d/apache2 restart')
  end
end