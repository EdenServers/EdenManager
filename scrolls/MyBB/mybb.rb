class MYBB < Scroll
  def initialize(name = 'MyBB', options = {})
    self.name = name
    self.type = 'MyBB'
    self.author = 'SofianeG'
    self.version = '1.6.11'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://resources.mybb.com/downloads/mybb_1611.zip'
    self.dependable = false
    super
  end

  def set_dependencies
    add_dep('Apache')
    add_dep('PHP')
    add_dep('MySQL')
  end

  def install
    download('mybb_1611.zip')
    copy('/var/www/', 'mybb_1611.zip')
    extract('zip', 'mybb_1611.zip', self.install_folder)
  end
end