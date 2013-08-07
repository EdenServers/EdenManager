class Database
  attr_accessor :database, :services
  def initialize
    @database = Sequel.connect('sqlite://database.db')

    #Installing databases
    unless @database.table_exists?(:services)
      Console.show 'Creating database...', 'info'
      @database.create_table :services do
        primary_key :id
        String :folderName
        String :startCommand
        String :serviceName
        String :serviceType
        String :pidFile
      end
    end

    #Set tables
    self.services=@database[:services]
  end
end
