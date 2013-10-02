class Scroll
  attr_accessor :name, :homepage, :author, :url, :version, :options, :install_folder, :pid_file ,:dependable

  def initialize(options = {})
    @options = options
    unless is_installed?
      Console.show "Installing scroll #{self.name} v#{self.version} made by #{self.author} <#{self.homepage}>",'info'
      self.dependable = true unless self.dependable
      self.install_folder=generate_install_folder
      self.pid_file=generate_pid_file
      @dependencies=Dependencies.new
      set_dependencies
    else
      raise DepAlreadyInstalledError
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
    FileUtils.mkdir_p(File.dirname("#{destination}/#{file}"))
    FileUtils.cp_r("#{folder}/#{file}", "#{destination}/#{file}")
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
      begin
      Console.show "Downloading #{filename} from #{self.url} to #{folder}", 'info'
      File.open("#{folder}/#{filename}", 'wb') do |saved_file|
        open(url, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
      Console.show 'Download complete !', 'success'
      folder + '/' + filename
      rescue Errno::ECONNREFUSED
        Console.show 'Error while downloading file.', 'error'
        raise InstallError
      end
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

  #Randomly generate the name of the pid file
  def generate_pid_file
    folder='./pid'
    unless File.exist?(folder)
      Console.show "Creating folder #{folder}", 'info'
      FileUtils.mkdir_p(folder)
    end
    pid_file = "./pid/#{rand(90000-10000) + 10000}.pid"
    while File.exist? pid_file
      pid_file = generate_pid_file
    end
    pid_file
  end

  #Randomly generate the install folder
  def generate_install_folder
    folder='./EdenApps'
    unless File.exist?(folder)
      Console.show "Creating folder #{folder}", 'info'
      FileUtils.mkdir_p(folder)
    end
    installFolder = "./EdenApps/#{SecureRandom.hex(6)}"
    while File.exist? installFolder
      installFolder = generate_pid_file
    end
    installFolder
  end

  #install all dependencies
  def install_dependencies
    @dependencies.install_dependencies
  end

  #We want to know if the scroll is installed
  def is_installed?
    if self.dependable
      $db.services.each do |service|
        if service[:service_name] == self.name
          return true
        end
      end
    end
    false
  end

  #This function register the installed scroll in database
  def register(start_command, home = self.install_folder)
    $db.services.insert(:service_name => self.name, :service_type => self.name, :folder_name => home, :start_command => start_command, :pid_file => self.pid_file, :version => self.version)
  end

  #This function is called to set the dependencies
  def set_dependencies
    Console.show 'There are no dependencies for this scroll', 'info'
  end

  #Update the scroll
  def update(service)
    Console.show "The service #{service} can not be updated", 'info'
  end
end