class Java < Scroll
  def initialize
    self.name = 'Java'
    self.author = 'Dernise'
    self.version = '1.7'
    self.homepage = 'http://wwww.edenservers.fr'
    super
  end

  def install(options = {})
    System.aptitude('update')
    System.aptitude('install', 'openjdk-7-jre')
  end
end
