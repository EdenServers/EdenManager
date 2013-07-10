class Scroll
  attr_accessor :name, :homepage, :author, :url

  def download(filename, folder= './downloads')
    if self.url.nil?
      Console.show 'Download request is nil or name is nil', 'error'
    else
      Console.show "Downloading #{filename} from #{self.url} to #{folder}", 'info'
      File.open("#{folder}/#{filename}", 'wb') do |saved_file|
        open(url, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
      Console.show 'Download complete !', 'success'
      folder + '/' + filename
    end
  end


end