require 'rubygems'
require 'colored'
require 'eventmachine'
require 'logger'
require 'yaml'

#Include
# Helpers
require './helpers/console'
require './helpers/configuration'
include Console
include Configuration

#Classes
require './classes/packet'

EM.run do
  Console.show 'Starting server...', 'info'
  Configuration.loadConfig

  EM.start_server '0.0.0.0', 12345, Packet
end





