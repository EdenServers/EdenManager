require 'socket'
require 'json'
require 'eventmachine'

class Manager < EM::Connection
  def self.send_data data
    TCPSocket.open "162.243.31.242", 12348 do |s|
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

puts Manager.send_data(JSON.generate({master_key: "azerty", packet_request: 'install', scroll_name: "Bukkit", scroll_options: {folder: 'minecraft_test', user:'dernise', port:25568, ram:310}}) + "\n")
puts Manager.send_data(JSON.generate({master_key: "azerty", packet_request: 'start', service_id: 1}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "azerty", packet_request: 'get_cpu', service_id: 1}) + "\n")
