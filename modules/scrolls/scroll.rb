class Scroll
  attr_accessor :name, :homepage, :author, :url, :version, :options, :install_folder ,:dependable

  def initialize(options = {})
    @options = options
    unless is_installed?
      Console.show "Installing scroll #{self.name} v#{self.version}  made by #{self.author} <#{self.homepage}>",'info'
      self.dependable = true unless self.dependable
      @dependencies=Dependencies.new
      set_dependencies
    else
      raise AlreadyInstalledError
    end
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

  #Copy a file to destination
  def copy(destination, file, folder = './downloads')
    FileUtils.mkdir_p(File.dirname(destination))
    FileUtils.cp_r("#{folder}/#{file}", destination)
  end

  #Download a file
  def download(filename, folder= './downloads')
    unless File.exist?(folder)
      Console.show "Creating folder #{folder}", 'info'
      FileUtils.mkdir_p(folder)
    end
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

  #Extract a file
  def extract(type, filename, destination, folder = './downloads/')
    case type
      when 'zip' #TODO: Make more archive types compatiblec
        Zip::ZipFile.open("./#{folder}/#{filename}") { |zip_file|
          zip_file.each { |f|
            f_path=File.join(destination, f.name)
            FileUtils.mkdir_p(File.dirname(f_path))
            zip_file.extract(f, f_path) unless File.exist?(f_path)
          }
        }
      else
        Console.show 'No type is specified or the type is not supported/wrong', 'error'
    end
  end

  #Generate the name of the pid file
  def generate_pid_file
    pid_file = "#{rand(90000-10000) + 10000}.pid"
    while File.exist?"./pid/#{pid_file}"
      pid_file = generate_pid_file
    end
    pid_file
  end

  #install all dependencies
  def install_dependencies
    @dependencies.install_dependencies
  end

  #We want to know if the scroll is installed
  def is_installed?
    $db.services.each do |service|
      if service[:serviceName] == self.name
        return true
      end
    end
    false
  end

  #This function register the installed scroll in database
  def register(home, start_command)
    pid_file = "./pid/#{generate_pid_file}"
    $db.services.insert(:serviceName => self.name, :folderName => home, :startCommand => start_command, :pidFile => pid_file)
  end

  #This function is called to set the dependencies
  def set_dependencies
    Console.show 'There are no dependencies for this scroll', 'info'
  end
end