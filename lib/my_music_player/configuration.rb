module MyMusicPlayer
  class Configuration
    attr_accessor :music_path

    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
      @db_adapter = DbAdapter.new
    end

  end
end
