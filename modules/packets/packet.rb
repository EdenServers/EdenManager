# Main class
# Interract with packets' API
class Packet < EM::Connection
  def receive_data data
    executeOrder if cutPacket data
  end

  # Method to decompose a packet
  # A packet is organized like that :
  # Master Key | Order | Data 1 | Data 2 | ...
  def cutPacket packet
    @request = packet.split("|")
    if @request[0] == "" || @request[1].nil? || @request[1] == ""
      Console.show "Packet without minimal size (no order or data). Packet content : #{packet}", 'error'
      false
    else
      @order = @request[1]
      Console.show "New request received : #{packet}", 'debug'
      true
    end
  end

  # Method who will analyse the order and execute it
  def executeOrder
    if @request[0] == $masterKey
      case @order
        ### GENERAL ###
        when "getStatus"
          #Interroger la BDD
          #Trouver le serveur et les infos
          #Renvoyer les infos

          send_data('{"ram": ' + Random.rand(1024).to_s + ', "cpu": ' + Random.rand(100).to_s + '}') #Format data to a json string
          send_data("\n") #Do not forget this shit !
        else
          close_connection
      end
    end
  end
end