begin
  $db.database.add_column :groups, :group_id, Integer, :unique => true
rescue Sequel::DatabaseError
  Console.show 'Migration already applied', 'info'
end