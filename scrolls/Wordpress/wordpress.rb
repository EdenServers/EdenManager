class WORDPRESS < Scroll
  def initialize(name = 'WordPress', options = {})
    self.name = name
    self.type = 'WordPress'
    self.author = 'SofianeG'
    self.version = '3.7.1'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://fr.wordpress.org/wordpress-3.7.1-fr_FR.zip'
    self.dependable = false
    super
  end

  def set_dependencies
    add_dep('Apache')
  end

  def install
    download('wordpress-3.7.1-fr_FR.zip')
    copy(self.install_folder, 'wordpress-3.7.1-fr_FR.zip')
    extract('zip', 'wordpress-3.7.1-fr_FR.zip', self.install_folder)
  end
end