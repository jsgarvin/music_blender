module MyMusicPlayer
  class DbAdapter
    attr_reader :connection

    def spin_up
      establish_db_connection
      silence_stream(STDOUT)  { initialize_or_migrate_db }
      setup_db_log
    end

    #######
    private
    #######

    def establish_db_connection
      @connection ||= ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => path_to_db
      )
    end

    def initialize_or_migrate_db
      if File.exist?(path_to_db)
         migrate_db
      else
        initialize_db
      end
    end

    def initialize_db
      load(path_to_schema) #load and run schema.rb
    end

    def migrate_db
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
      File.open(path_to_schema, 'w:utf-8') do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    def path_to_db
      @path_to_db ||= "#{PLAYER_ROOT}/db/my_music_player.db"
    end

    def path_to_schema
      @path_to_schema ||= "#{PLAYER_ROOT}/db/schema.rb"
    end

    def setup_db_log
      ActiveRecord::Base.logger ||= Logger.new(File.open("#{PLAYER_ROOT}/log/database.log", 'a'))
    end
  end
end
