class Java < Scroll
  def initialize(name = 'Java', options = {})
    self.name = name
    self.type = 'Java'
    self.author = 'Dernise'
    self.version = '1.7'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = true
    super
  end

  def install
    register('java -version', '/usr/bin/java')
    System.apt_get('update')
    System.apt_get('install', 'openjdk-7-jre')
    update_status
  end
end
