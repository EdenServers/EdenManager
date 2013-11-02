class PHPBB < Scroll
  def initialize(name = 'PHPBB', options = {})
    self.name = name
    self.type = 'PHPBB'
    self.author = 'SofianeG'
    self.version = '3.0.11'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://www.phpbb.fr/telechargement/phpBB-3.0.11-fr.zip'
    self.dependable = false
    super
  end

  def set_dependencies
    add_dep('Apache')
    add_dep('PHP')
    add_dep('MySQL')
  end

  def install
    download('phpBB-3.0.11-fr.zip')
    copy('/var/www/', 'phpBB-3.0.11-fr.zip')
    extract('zip', 'phpBB-3.0.11-fr.zip', self.install_folder)
  end
end