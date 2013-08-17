 # Gems (don't forget to do a `bundle install` before running this software)
require 'rubygems'

require 'colored'
require 'daemons'
require 'eventmachine'
require 'io/wait'
require 'json'
require 'logger'
require 'open3'
require 'open-uri'
require 'zip/zip'
require 'rufus/scheduler'
require 'sequel'
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

  Console.show 'Loading managers...', 'info'
  ServiceManager.init
  Console.show 'Managers loaded', 'info'

  SampleScroll = ScrollInstaller.new('Bukkit', {folder: 'minecraft_test', user:'dernise', port:25568})
  SampleScroll.install

  ServiceManager.start_service(2)
  #ServiceManager.start_service(3)
  #ServiceManager.start_service(4)

  EM.start_server '0.0.0.0', 12348, Packet

  Console.show 'Manager is running !', 'success'
end
