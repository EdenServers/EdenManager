# Gems (don't forget to do a `bundle install` before running this software)
require 'rubygems'

require 'colored'
require 'daemons'
require 'eventmachine'
require 'logger'
require 'open3'
require 'open-uri'
require 'zip/zip'
require 'rufus/scheduler'
require 'shellwords'
require 'yaml'

#Loader
# Helpers
Dir["./helpers/*.rb"].each {|file| require file }

# Modules
Dir['./modules/**/initializer.rb'].each{ |f| require f }

#Main Loop
EM.run do
  Console.show 'Starting manager...', 'info'
  Configuration.loadConfig
  Console.show 'Config loaded !', 'success'

  #Rufus Scheduler
  Console.show 'Loading scheduler...', 'info'
  $scheduler = Rufus::Scheduler::EmScheduler.start_new
  Console.show 'Scheduler loaded !', 'success'

  #SampleScroll = ScrollInstaller.new('bukkit', {folder: 'minecraft_test', user:'dernise', port:25568})
  #SampleScroll.install

  #Sample
  #procTest = Monitoring::Process.new('Minecraft', 'java -jar -Xmx380M -Xms380M ' + Dir.pwd.to_s + '/repository/minecraft/bukkit/craftbukkit.jar')
  #procTest.pid_file = Dir.pwd.to_s + '/trash_folder/test.pid'
  #procTest.working_dir= Dir.pwd.to_s + '/trash_folder/minecraft'
  #procTest.start_process

  EM.start_server '0.0.0.0', 12348, Packet

  Console.show 'Manager is running !', 'success'
end
