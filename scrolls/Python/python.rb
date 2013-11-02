class PYTHON < Scroll
  def initialize(name = 'Python', options = {})
    self.name = name
    self.type = 'Python'
    self.author = 'SofianeG'
    self.version = '2.7'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = false
    super
  end

  def install
    add_source ("ppa:fkrull/deadsnakes")
    System.apt_get('update')
    System.apt_get('install', 'python2.7')
  end
end