module MyMusicPlayer
  class Configuration
    attr_accessor :music_path, :root_folder

    def initialize(hash)
      hash.keys.each do |key|
        send("#{key}=", hash[key])
      end
      initialize_db
      @root_folder = RootFolder.find_or_create_by(:path => music_path)
    end

    #######
    private
    #######

    def initialize_db
      DbAdapter.new.spin_up
    end

  end
end
