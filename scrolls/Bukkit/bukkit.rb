class Bukkit < Scroll
  def initialize
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

  def install(options = {})
    download('craftbukkit.jar')
    copy("/home/#{options[:user]}/#{options[:folder]}/craftbukkit.jar", 'craftbukkit.jar')
    copy("/home/#{options[:user]}/#{options[:folder]}/server.properties", 'server.properties', './scrolls/Bukkit')
    System.gem('install','java_properties')
    require 'java_properties'
    props = JavaProperties::Properties.new("/home/#{options[:user]}/#{options[:folder]}/server.properties")
    props.each do |key,value|
      puts "#{key} = #{value}"
    end
  end
end