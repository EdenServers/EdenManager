begin
  $db.database.add_column :services, :user_id, Integer
rescue Sequel::DatabaseError
  Console.show 'Migration already applied', 'info'
end