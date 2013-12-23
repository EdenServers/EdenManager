class SteamcmdController < Controller
  def initialize
    super('Steamcmd')
  end

  def parse_request(packet)
  end

  def install_game(game_id, directory)
    p1 = Process.fork {
        if ::Process::Sys.geteuid == 0
          uid_num = Etc.getpwnam('EdenManager').uid
          ::Process::Sys.setuid(uid_num) if uid
        end
        system("./EdenApps/Steamcmd/Steamcmd/steamcmd.sh +login anonymous +force_install_dir #{directory} +app_update #{game_id} validate +quit")
        exit
    }
    Process.detach(p1)
  end
end