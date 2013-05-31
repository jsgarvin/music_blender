module MyMusicPlayer
  class Scanner
    include Singleton

    def ls
      files = []
      Find.find(music_path) { |file| files << file }
      return files
    end

    #######
    private
    #######
    
    def music_path
      Configuration.instance.music_path
    end

  end
end
