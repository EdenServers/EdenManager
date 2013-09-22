require 'socket'
require 'json'

s = TCPSocket.new 'localhost', 12348

s.puts JSON.generate({packet_id: 1,scroll_name: "Bukkit", scroll_options: {folder: 'minecraft_test', user:'dernise', port:25568, ram:310}})
result = JSON.parse(s.gets)
s.puts JSON.generate({packet_id: 2, service_id: result['service_id']}) #start process

puts s.gets # Read lines from socket
s.close             # close socket when done
