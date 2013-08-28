module MyMusicPlayer
  class Configuration
    attr_accessor :music_path

    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
      initialize_db
    end

    def initialize_db
      DbAdapter.new.spin_up
      @root_folder = RootFolder.find_or_create_by(:path => music_path)
      puts @root_folder.inspect
      Dir["#{music_path}/**/*.mp3"].each do |path|
        puts path
      end
    end

  end
end
