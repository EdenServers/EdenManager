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

  def get_craftbukkit_url build_number
    string = "http://dl.bukkit.org/api/1.0/downloads/projects/craftbukkit/view/build-#{build_number}"
    begin
      url = JSON.parse HTTPClient.new.get_content(string)
      url = url['file']['url']
      "http://dl.bukkit.org#{url}"
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
        Downloader.plugin_download(url, folder, url.split("/").last)
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
          if line[0] != "#"
            temp = line.split("=")
            config[temp[0]] = temp[1].to_s.chomp
          end
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
          if line[0] != "#"
            temp = line.split("=")
            config[temp[0]] = temp[1].to_s.chomp
          end
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

  def change_bukkit_version id_service, build_number
    begin
      service = ServiceSystem::Service.new(id_service)
      folder = service.service[:folder_name]

      url = get_craftbukkit_url build_number
      if url.nil?
        Console.show "Can't download bukkit version #{build_number}", 'debug'
        false
      else
        Downloader.download(url, folder, "craftbukkit.jar")
        Console.show "Finished download bukkit V#{build_number} !", 'debug'
      end
    rescue ServiceNotInstalledError
      Console.show "Seems to not be a bukkit server, installation aborted.", 'debug'
      false
    end
  end
end

include Minecraft