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

    end
  end
end