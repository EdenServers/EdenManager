class Database
  attr_accessor :database, :services, :monitors, :monitor_services
  def initialize
    @database = Sequel.connect('sqlite://database.db')

    #Installing databases
    unless @database.table_exists?(:services)
      Console.show 'Creating database...', 'info'
      @database.create_table :services do
        primary_key :id
        String :folder_name
        String :start_command
        String :service_name
        String :service_type
        String :pid_file
        Integer :running
        Integer :dependency
        String :version
      end
    end

    unless @database.table_exists?(:monitor_services)
      @database.create_table :monitor_services do
        primary_key :id
        String :ram_usage
        String :cpu_usage
        Date :date
        Integer :service_id
      end
    end

    unless @database.table_exists?(:monitors)
      @database.create_table :monitors do
        primary_key :id
        String :ram_usage
        String :cpu_usage
        Date :date
      end
    end


    #Set tables
    self.monitors=@database[:monitors]
    self.monitor_services=@database[:monitor_services]
    self.services=@database[:services]

    #Make all services DOWN.
    self.services.update(:running => 0)
  end
end
