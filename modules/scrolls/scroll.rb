class Scroll
  attr_accessor :name, :homepage, :author, :url, :version


  def initialize
    Console.show "Installing scroll #{self.name} v#{self.version}  made by #{self.author} <#{self.homepage}>",'info'
    @dependencies=Dependencies.new
    set_dependencies

  end

  #add a dependency
  def add_dep(dep)
    @dependencies.add_dependency(dep)
  end

  #add a source to /etc/sources.list (debian based distro only)
  def add_source (source)
    open('/etc/apt/sources.list', 'a') { |f|
      f.puts source
    }
  end

  #Download a file
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

  #install all dependencies
  def install_dependencies
    @dependencies.install_dependencies
  end

  def install_gem(gem)
    System.gem
  end

  #This function is called to set the dependencies
  def set_dependencies
    Console.show 'There are no dependencies for this scroll', 'info'
  end
end