require "sequel"

Console.show 'Loading database...', 'info'

$db = Sequel.connect('sqlite://database.db')

unless $db.table_exists?(:servers)
  Console.show 'Creating database...', 'info'
  $db.create_table :servers do
    primary_key :id
    Integer :idServer
    String :folderName
    String :startCommand
    String :service
  end
end

Console.show 'Database loaded !', 'success'
