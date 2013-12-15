class TeamspeakController < Controller
  def initialize
    super('Teamspeak')
  end

  def parse_request(packet)
    case packet['packet_request']
      when 'get_tokens'
        return get_tokens packet['service_id']
      else
        Console.show "Unknown packet : #{packet}"
        return {status: 'Error'}
    end
  end

  def get_tokens(id)
    tokens = Array.new
    server = $db.services.where(id => id).first
    db_path = "#{server[:folder_name]}/ts3server.sqlitedb"
    if File.exist?(db_path)
      db = SQLite3::Database.new(db_path)
      db.execute( "select * from tokens" ) do |row|
        tokens << row[1]
      end
      return {status: 'OK', tokens: tokens}
    else
      return {status: 'ERROR', message: 'NO DATABASE'}
    end
  end
end