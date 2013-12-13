#Configuration helper provide methods for manipulate the config file
module Configuration
  attr_accessor :config, :serverName, :masterKey

  def load_config
    Console.show 'Loading config...', 'info'

    begin
      @config = YAML.load_file('config.yml')
      @serverName = config['serverName']
      @masterKey = config['masterKey']
    rescue Errno::ENOENT
      Console.show "Config file doesn't exists !", 'error'
      Console.show 'Stopping server', 'error'
      EM.stop
    end
  end

  def set_config_opt(config_name, value)
     @config[config_name] = value
     File.write('config.yml', @config.to_yaml)
  end
end

include Configuration