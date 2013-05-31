module MyMusicPlayer
  class Configuration
    include Singleton

    attr_accessor :music_path

    def set(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
    end

  end
end
