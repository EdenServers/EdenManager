require 'socket'
require 'json'
require 'eventmachine'

class Manager < EM::Connection
  def self.send_data data
    TCPSocket.open "127.0.0.1", 12348 do |s|
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
puts Manager.send_data(JSON.generate({packet_request:"get_tokens",service_id: 1 ,master_key:"fe5cab0692e5e82c76b2581398ab60cd", controller: "Teamspeak"}) + "\n")
#puts Manager.send_data(JSON.generate({packet_request: 'start_service',service_id:"14",master_key:"94af27ba9cdb7a58e779a8a751301b52"}) + "\n")
#puts Manager.send_data(JSON.generate({packet_request: 'get_informations'}) + "\n")
#puts Manager.send_data(JSON.generate({packet_request: 'add_linux_user', master_key: "BopMasterKey", username:"testaef", password:"livebox", home_directory: "/home/test"}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "BopMasterKey", packet_request: 'generate_master_key'}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "1234", packet_request: 'install', scroll_name: "Bukkit", scroll_options: {folder: 'minecraft_test', user:'dernise', port:25568, ram:310}}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "1234", packet_request: 'start', service_id: 2}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "1234", packet_request: 'get_ram', service_id: 2}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "BopMasterKey", packet_request: 'install', scroll_name: "Php", scroll_options: {}}) + "\n")
#puts Manager.send_data(JSON.generate({packet_request: 'get_informations'}) + "\n")
#puts Manager.send_data(JSON.generate({master_key: "BopMasterKey", packet_request: 'generate_master_key'}) + "\n")

