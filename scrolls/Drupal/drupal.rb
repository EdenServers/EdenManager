class DRUPAL < Scroll
  def initialize(name = 'Drupal', options = {})
    self.name = name
    self.type = 'Drupal'
    self.author = 'SofianeG'
    self.version = '7.23'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://ftp.drupal.org/files/projects/drupal-7.23.zip'
    self.dependable = false
    super
  end

  def set_dependencies
    add_dep('Apache')
    add_dep('PHP')
    add_dep('MySQL')
  end

  def install
    download('drupal-7.23.zip')
    copy('/var/www/', 'drupal-7.23.zip')
    extract('zip', 'drupal-7.23.zip', self.install_folder)
  end
end