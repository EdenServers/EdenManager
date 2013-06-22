class Packet < EM::Connection
  def receive_data data
    executeOrder if cutPacket data
  end

  #Fonction de découpage des paquets
  #Un paquet est defini comme suivant
  # Master Key | Ordre | Data 1 | Data 2 | ...
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

  #Methode qui va analyser l'ordre et le transmettre aux autres classes pour effectuer les actions
  #C'est ici qu'il faut mettre un switch géant ^^
  #La masterkey est vérifiée ici
  #A chaque cas il faut bien sûr verifier que l'ensemble des données requises existe
  def executeOrder
    if @request[0] == $masterKey
      case @order

      end
    end
  end

end