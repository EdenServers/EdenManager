class Java < Scroll
  def initialize
    self.name = 'Java'
    self.author = 'Dernise'
    self.version = '1.7'
    self.homepage = 'http://wwww.edenservers.fr'
    super
  end

  def install
    System.apt_get('update')
    System.apt_get('install', 'openjdk-7-jre')
  end
end
