class WEBCRAFTED < Scroll
  def initialize(name = 'WebCrafted', options = {})
    self.name = name
    self.type = 'WebCrafted'
    self.author = 'SofianeG'
    self.version = '0.7.2'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://dl.rellynn.eu/WEBCrafted0-7-2.zip'
    self.dependable = false
    super
  end

  def set_dependencies
    add_dep('Apache')
    add_dep('PHP')
    add_dep('MySQL')
    add_dep('PHPMyAdmin')
  end

  def install
    download('WEBCrafted0-7-2.zip')
    copy('/var/www/', 'WEBCrafted0-7-2.zip')
    extract('zip', 'WEBCrafted0-7-2.zip', self.install_folder)
  end
end