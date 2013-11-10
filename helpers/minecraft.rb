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
        Console.show "Can't find a plugin named #{name}", 'error'
        false
      else
        Downloader.download(url, folder, url.split("/").last)
        Console.show "Finished download the plugin #{name} to #{folder}", 'success'
      end
    rescue ServiceNotInstalledError
      Console.show "Seems to not be a bukkit server, installation aborted.", 'error'
      false
    end
  end
end

include Minecraft