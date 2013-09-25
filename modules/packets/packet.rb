# Main class
# Interract with packets' API
class Packet < EM::Connection
  def receive_data data
    length = data.length
    if length >= 2
      packet = JSON.parse(data)
      if checkMasterKey packet['master_key']
        case packet['packet_request']
          when 'install' #Install
            installation = ScrollInstaller.new(packet['scroll_name'], packet['scroll_options'])
            status = installation.install
            send_data JSON.generate({status: status}) + "\n" #Don't forget this shit again !
          when 'start' #Start
            ServiceManager.start_service(packet['service_id'])
            send_data JSON.generate({status: 'OK'}) + "\n" #Don't forget this shit again !
          else
            Console.show "Unknown packet : #{packet}"
            close_connection
        end
      else
        Console.show "Master key is invalid : #{packet}", 'error'
        close_connection
      end
    else
      Console.show "Just got a wrong packet with length : #{length}", 'error'
      close_connection
    end
  end

  #Check if the measterKey is the same as in config file
  def checkMasterKey masterKey
    return true if masterKey == $masterKey
    return false
  end
end