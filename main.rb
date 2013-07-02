# Gems (don't forget to do a `bundle install` before running this software)
require 'rubygems'

require 'colored'
require 'daemons'
require 'eventmachine'
require 'logger'
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
  Configuration.loadConfig
  Console.show 'Starting server...', 'info'

  #Rufus Scheduler
  $scheduler = Rufus::Scheduler::EmScheduler.start_new

  #Sample
   procTest = Monitoring::Process.new('Minecraft', 'java -jar -Xmx380M -Xms380M /home/dernise/minecraft/craftbukkit.jar')
   procTest.pid_file = '/home/dernise/test.pid'
   procTest.working_dir='/home/dernise/minecraft'
   procTest.start_process

  EM.start_server '0.0.0.0', 12346, Packet
end