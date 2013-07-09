Console.show 'Loading database...', 'info'
ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'database.db'
)

require_relative 'servers'

unless ActiveRecord::Base.connection.table_exists? 'servers'
  Console.show 'Creating database...', 'info'
  ActiveRecord::Migration.class_eval do
    create_table :servers do |t|
      t.integer :idServer
      t.string  :folderName
      t.string :service
    end
  end
  Console.show 'Database created !', 'success'
end

Console.show 'Database loaded !', 'success'