begin
  $db.database.add_column :services, :username, String
rescue Sequel::DatabaseError
  Console.show 'Migration already applied', 'info'
end