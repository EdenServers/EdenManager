require_relative './database'

Console.show 'Loading database...', 'info'

$db = Database.new
#Executing Migrations
Dir['./modules/database/migrations/*.rb'].each {|file| require file }

Console.show 'Database loaded !', 'success'
