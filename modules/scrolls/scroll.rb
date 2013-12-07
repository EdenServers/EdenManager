class Scroll
  attr_accessor :name, :type, :homepage, :author, :url, :version, :options, :install_folder, :pid_file ,:dependable

  def initialize(options, name)
    @options = options
    unless is_dependency_installed?
      check_name
      Console.show "Installing scroll #{self.type} v#{self.version} made by #{self.author} <#{self.homepage}>",'info'
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

  def check_name
    name_correct = 0
    i = 1
    self.name = self.type if self.name.nil? || self.name.empty? #If no name is given (Dependency)
    until name_correct == 1 do
      name_correct = 1
      $db.services.each do |service|
        if service[:service_name] == self.name
          self.name=self.name + "(#{i})"
          i=i+1
          name_correct = 0
        end
      end
    end
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
      when 'tar.gz'
        `tar -zxvf #{filename}`
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
    installFolder = "./EdenApps/#{self.type}/#{self.name}"
    installFolder
  end

  #install all dependencies
  def install_dependencies
    @dependencies.install_dependencies
  end

  #We want to know if the scroll is installed
  def is_dependency_installed?
    if self.dependable
      $db.services.each do |service|
        if service[:service_type] == self.type
          return true
        end
      end
    end
    false
  end

  #This function register the installed scroll in database
  def register(start_command, home = self.install_folder)
    dependency = 0
    dependency = 1 if self.dependable
    username = 'EdenManager'
    unless options.nil?
      unless options['username'].nil?
        username = options['username']
      end
    end
    $db.services.insert(:service_name => self.name, :service_type => self.type, :username => username, :folder_name => home, :status => 'Installing', :start_command => start_command, :pid_file => self.pid_file, :running => 0, :dependency => dependency, :version => self.version)
  end

  def replace_in_file(file, before, after)
    read_file = File.read("#{install_folder}/#{file}")
    replace = read_file.gsub(/#{before}/, after)
    File.open("#{install_folder}/#{file}", 'w') {|file| file.puts replace}
  end

  #This function is called to set the dependencies
  def set_dependencies
    Console.show 'There are no dependencies for this scroll', 'info'
  end

  def set_permissions
    unless options.nil?
      unless options['chmod'].nil?
         File.chmod_R(options['chmod'], self.install_folder)
      else
        Console.show 'Setting permissions to 0770', 'info'
        FileUtils.chmod_R(0770, self.install_folder)
      end
      unless options['group'].nil? && options['username'].nil?
        FileUtils.chown_R(options['group'],options['username'],self.install_folder)
      else
        FileUtils.chown_R('EdenManager','EdenManager',self.install_folder)
      end
    else
      Console.show 'Setting permissions to 0770', 'info'
      FileUtils.chmod_R(0770, self.install_folder)
      FileUtils.chown_R('EdenManager','EdenManager',self.install_folder)
    end
  end

  #Update the scroll
  def update(service)
    Console.show "The service #{service} can not be updated", 'info'
  end

  def update_status
    $db.services.where(:status=>'Installing', :service_name => self.name).update(:status => 'OK')
  end
end