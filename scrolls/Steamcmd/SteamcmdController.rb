class SteamcmdController < Controller
  def initialize
    super('Steamcmd')
  end

  def parse_request(packet)
  end

  def install_game(game_id, directory)
    p1 = Process.fork {
      if ::Process::Sys.geteuid == 0
        infos = Etc.getpwnam('EdenManager')
        ::Process::Sys.setuid(infos.uid)
        ENV['HOME'] = infos.dir
      end
      system("./EdenApps/Steamcmd/Steamcmd/steamcmd.sh +login anonymous +force_install_dir #{directory} +app_update #{game_id} validate +quit")
      exit
    }
    Process.waitpid(p1, 0)
  end
end
