module Downloader
  def download url, path, filename
    Console.show "Started download #{url} !", 'debug'

    File.open("#{path}/plugins/#{filename}", "wb") do |saved_file|
      open(url, 'rb') do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end
end

include Downloader