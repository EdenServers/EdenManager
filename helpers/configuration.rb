#Configuration helper provide methods for manipulate the config file
module Configuration
  def loadConfig
    Console.show 'Loading config...', 'info'

    begin
      $config = YAML.load_file('config.yml')
      $serverName = $config['serverName']
      $masterKey = $config['masterKey']
    rescue Errno::ENOENT
      Console.show "Config file doesn't exists !", 'error'
      Console.show 'Stopping server', 'error'
      EM.stop
    end
  end
end

include Configuration