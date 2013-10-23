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


#Updating installation, currently hard codded.
`git pull`

#Loader
# Helpers
Dir["./helpers/*.rb"].each {|file| require file }

# Modules
Dir['./modules/**/initializer.rb'].each{ |f| require f }

System.daemonize_process do
  #Main Loop
  EM.run do
    Console.show 'Starting manager...', 'info'
    Configuration.load_config
    Console.show 'Config loaded !', 'success'

    #Rufus Scheduler
    Console.show 'Loading scheduler...', 'info'
    Scheduler.start
    Console.show 'Scheduler loaded !', 'success'

    Console.show 'Loading managers...', 'info'
    ServiceManager.new

    EM.start_server '0.0.0.0', 12348, Packet

    Console.show 'Manager is running !', 'success'
  end
end
