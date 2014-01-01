class Vsftpd < Scroll
  def initialize(name = 'Vsftpd', options = {})
    self.name = name
    self.type = 'Vsftpd'
    self.author = 'Dernise'
    self.version = '3.0.2'
    self.homepage = 'http://wwww.edenservers.fr'
    self.dependable = true
    super
  end

  def install
    register('/etc/init.d/vsftpd restart')
    add_source('deb http://ftp.fr.debian.org/debian/ unstable main')
    System.apt_get('update')
    System.apt_get('install', 'vsftpd')
    copy('/etc', 'vsftpd.conf', './scrolls/Vsftpd')
    `/etc/init.d/vsftpd restart`
    update_status
  end
end