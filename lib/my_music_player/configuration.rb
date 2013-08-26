module MyMusicPlayer
  class Configuration
    attr_accessor :db_connection, :music_path, :player_root

    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
      establish_db_connection
      setup_db_log
    end

    #######
    private
    #######

    def establish_db_connection
      @db_connection ||= ActiveRecord::Base.establish_connection(
        :adapter => 'sqlite3',
        :database => "#{PLAYER_ROOT}/db/test.db"
      )
    end

    def setup_db_log
      ActiveRecord::Base.logger ||= Logger.new(File.open("#{PLAYER_ROOT}/log/database.log", 'a'))
    end

  end
end
