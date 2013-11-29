class PHP < Scroll
  def initialize(name = 'Mumble', options = {})
    self.name = name
    self.type = 'Mumble'
    self.author = 'Samas92i'
    self.version = '1.0'
    self.homepage = 'http://wwww.skillsoldiers.fr'
    self.dependable = false
    self.options = options
    super
  end

  def install
    System.apt_get('update')
    System.apt_get('install mumble-server -y')
    copy('/etc', 'mumble-server.ini', './scrolls/Mumble')
    replace_in_file('/etc/mumble-server.ini', '<!port>', self.options['port'])
    replace_in_file('/etc/mumble-server.ini', '#serverpassword=', '#serverpassword=' + self.options['serverpassword'])
    replace_in_file('/etc/mumble-server.ini', '<!users>', self.options['users'])
    replace_in_file('/etc/mumble-server.ini', '<!welcometext>', self.options['welcometext'])
    replace_in_file('/etc/mumble-server.ini', '<!serverName>', self.options['serverName'])
    register('/etc/init.d/mumble-server stop && /etc/init.d/mumble-server start')
  end
end
