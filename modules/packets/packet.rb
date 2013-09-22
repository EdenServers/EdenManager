# Main class
# Interract with packets' API
class Packet < EM::Connection
  def receive_data data
    length = data.length
    if length >= 2
      packet = JSON.parse(data)
      case packet['packet_id']
        when 1 #Install
          installation = ScrollInstaller.new(packet['scroll_name'], packet['scroll_options'])
          id = installation.install
          send_data JSON.generate({status: 'OK', service_id: id}) + "\n" #Don't forget this shit again !
        when 2 #Start
          ServiceManager.start_service(packet['service_id'])
          send_data JSON.generate({status: 'OK'}) + "\n" #Don't forget this shit again !
        else
          Console.show "Unknown packet : #{packet}"
      end
    else
      Console.show "Just got a wrong packet with length : #{length}", 'error'
    end
  end
end