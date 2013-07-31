class Bukkit < Scroll
  def initialize(options = {})
    self.name = 'Bukkit'
    self.author = 'Dernise'
    self.version = '2788'
    self.dependable = false
    self.homepage = 'http://wwww.edenservers.fr'
    self.url = 'http://dl.bukkit.org/downloads/craftbukkit/get/02169_1.5.2-R1.0/craftbukkit.jar'
    super
  end

  def set_dependencies
    add_dep('Java')
  end

  def install
    download('craftbukkit.jar')
    copy("/Users/#{@options[:user]}/#{@options[:folder]}/craftbukkit.jar", 'craftbukkit.jar')
    copy("/Users/#{@options[:user]}/#{@options[:folder]}/server.properties", 'server.properties', './scrolls/Bukkit')
    register("/Users/#{@options[:user]}/#{@options[:folder]}", 'java -jar craftbukkit.jar')
  end
end