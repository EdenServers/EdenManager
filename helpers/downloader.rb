module Downloader
  def plugin_download(url, path, filename)
    Console.show "Started download #{url} !", 'debug'

    begin
      File.open("#{path}/plugins/#{filename}", "wb") do |saved_file|
        open(url, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
    rescue Errno::ENOENT
      Console.show "Can't download this file", 'debug'
    end
  end

  def download url, path, filename
    Console.show "Started download #{url} !", 'debug'

    begin
      File.open("#{path}/#{filename}", "wb") do |saved_file|
        open(url, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
    rescue Errno::ENOENT
      Console.show 'Can\'t download this file', 'debug'
    rescue Errno::ECONNREFUSED
      Console.show 'Error while downloading file', 'error'
    rescue => e
      Console.show e, 'error'
    end
  end
end

include Downloader