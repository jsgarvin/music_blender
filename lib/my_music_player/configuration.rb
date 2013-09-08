module MyMusicPlayer
  class Configuration
    attr_accessor :music_path

    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
    end

    def root_folder
      @root_folder ||= RootFolder.find_or_create_by(:path => music_path)
    end

  end
end
