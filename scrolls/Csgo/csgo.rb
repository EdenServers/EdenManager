class Csgo < Scroll
  def initialize(options = {}, name = 'Csgo')
    self.name = name
    self.type = 'Csgo'
    self.author = 'Dernise'
    self.version = '1'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.options = options
    super
  end

  def set_dependencies
    add_dep('Steamcmd')
  end

  def install #No time: hardcoding
    register('./srcds_run -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_bomb +map de_dust')
    ControllersManager.get_controller('Steamcmd').install_game(740, self.install_folder)
    set_permissions
    update_status
  end

  def uninstall(id) #TODO: Recode this. Really.
    self.install_folder = $db.services.where(id: id).first[:folder_name]
    puts `rm -R #{self.install_folder}`
    $db.services.where(id: id).delete
  end
end