class SteamcmdController < Controller
  def initialize
    super('Steamcmd')
  end

  def parse_request(packet)
  end

  def install_game(game_id, directory)
    system("./EdenApps/Steamcmd/Steamcmd/steamcmd.sh +login anonymous +force_install_dir #{directory} +app_update #{game_id} validate +quit")
  end
end