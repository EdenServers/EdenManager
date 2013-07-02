require 'rubygems'
require 'colored'
require 'eventmachine'
require 'logger'
require 'yaml'
require 'daemons'
require 'shellwords'
require 'rufus/scheduler'

#Include
# Helpers
require './helpers/console'
require './helpers/configuration'
require './monitor/system'
require './monitor/process'

include Console
include Configuration
include Monitoring::System


#Classes
require './classes/packet'

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

  EM.start_server '0.0.0.0', 12345, Packet
end





