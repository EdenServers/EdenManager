module Minecraft
  def get_plugin_url name
    string = "http://api.bukget.org/3/plugins/bukkit/#{name}"
    begin
      plugin = JSON.parse HTTPClient.new.get_content(string)
      plugin['versions'].first['download']
    rescue HTTPClient::BadResponseError
      nil
    end
  end

  def download_plugin id_service, name
    begin
      service = ServiceSystem::Service.new(id_service)
      folder = service.service[:folder_name]
      url = get_plugin_url name

      if url.nil?
        Console.show "Can't find a plugin named #{name}", 'debug'
        false
      else
        Downloader.download(url, folder, url.split("/").last)
        Console.show "Finished download the plugin #{name} to #{folder}", 'debug'
      end
    rescue ServiceNotInstalledError
      Console.show "Seems to not be a bukkit server, installation aborted.", 'debug'
      false
    end
  end

  def get_minecraft_config id_service
    config = Hash.new
    begin
      service = ServiceSystem::Service.new(id_service)
      folder = service.service[:folder_name]

      begin
        File.open("#{folder}/server.properties", "r").each_line do |line|
          temp = line.split("=")
          config[temp[0]] = temp[1].to_s.chomp
        end

        config
      rescue Errno::ENOENT
        nil
      end
    rescue ServiceNotInstalledError
      nil
    end
  end

  def change_minecraft_config id_service, key, value
    config = Hash.new
    begin
      service = ServiceSystem::Service.new(id_service)
      folder = service.service[:folder_name]

      begin
        File.open("#{folder}/server.properties", "r").each_line do |line|
          temp = line.split("=")
          config[temp[0]] = temp[1].to_s.chomp
        end

        config[key] = value

        file = File.open("#{folder}/server.properties", "w+")
        config.each do |k, v|
          file.write("#{k}=#{v}\n")
        end
        file.close
        true
      rescue Errno::ENOENT
        nil
      end
    rescue ServiceNotInstalledError
      nil
    end
  end
end

include Minecraft