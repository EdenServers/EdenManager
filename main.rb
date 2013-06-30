require 'rubygems'
require 'colored'
require 'eventmachine'
require 'logger'
require 'yaml'
require 'daemons'
require 'shellwords'

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

  #Sample
  procTest = Monitoring::Process.new('Minecraft', 'java -jar /home/dernise/minecraft/craftbukkit.jar')

  EM.start_server '0.0.0.0', 12345, Packet
end





