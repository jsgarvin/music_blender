module MyMusicPlayer
  class DbAdapter
    attr_reader :connection

    def initialize
      establish_db_connection
      initialize_or_migrate_db
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
      if File.exist?(path_to_db) or ! File.exist?(path_to_schema)
        silence_stream(STDOUT)  { migrate_db }
      else
        silence_stream(STDOUT) { initialize_db }
      end
    end

    def migrate_db
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
      File.open(path_to_schema, 'w:utf-8') do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end

    def initialize_db
      load(path_to_schema) # <-- mystery `load` method gets polluted into
                           #     global namespace by ActiveRecord.
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
