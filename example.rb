require 'socket'
require 'json'

s = TCPSocket.new 'localhost', 12348

#s.puts JSON.generate({packet_id: 2, service_id: 6}) #start process
s.puts JSON.generate({packet_id: 1,scroll_name: "Bukkit", scroll_options: {folder: 'minecraft_test', user:'dernise', port:25568}})

puts s.gets # Read lines from socket
s.close             # close socket when done
