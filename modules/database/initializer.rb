require "sequel"
require_relative './database'

Console.show 'Loading database...', 'info'

$db = Database.new

Console.show 'Database loaded !', 'success'
