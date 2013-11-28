class LAPISCRAFT < Scroll
  def initialize(name = 'LapisCraft', options = {})
    self.name = name
    self.type = 'LapisCraft'
    self.author = 'SofianeG'
    self.version = '0.1'
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://eywek.fr/downloads/BETA_LAPISCRAFT.zip'
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
    download('BETA_LAPISCRAFT.zip')
    copy('/var/www/', 'BETA_LAPISCRAFT.zip')
    extract('zip', 'BETA_LAPISCRAFT.zip', self.install_folder)
  end
end