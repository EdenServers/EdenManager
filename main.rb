# Gems (don't forget to do a `bundle install` before running this software)
require 'rubygems'

require 'colored'
require 'daemons'
require 'eventmachine'
require 'logger'
require 'open3'
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
  Console.show 'Starting server...', 'info'
  Configuration.loadConfig
  Console.show 'Starting manager...', 'info'

  #Rufus Scheduler
  $scheduler = Rufus::Scheduler::EmScheduler.start_new

  #Sample
  #procTest = Monitoring::Process.new('Minecraft', 'java -jar -Xmx380M -Xms380M ' + Dir.pwd.to_s + '/repository/minecraft/bukkit/craftbukkit.jar')
  #procTest.pid_file = Dir.pwd.to_s + '/trash_folder/test.pid'
  #procTest.working_dir= Dir.pwd.to_s + '/trash_folder/minecraft'
  #procTest.start_process

  EM.start_server '0.0.0.0', 12348, Packet

  Console.show 'Manager is running !', 'warn'
end
