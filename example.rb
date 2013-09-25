require 'socket'
require 'json'
require 'eventmachine'

class Manager < EM::Connection
  def self.send_data data
    TCPSocket.open "localhost", 12348 do |s|
      s.send data, 0
      if line = s.gets
        response = line
        response.delete("\n")
        response = JSON.parse(response.gsub('\"', '"'))
      else
        response = nil
      end
      return response
    end
  end
end

puts Manager.send_data(JSON.generate({packet_request: 'install', scroll_name: "Bukkit", scroll_options: {folder: 'minecraft_test', user:'dernise', port:25568, ram:310}}) + "\n")
