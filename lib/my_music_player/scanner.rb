module MyMusicPlayer
  class Scanner

    def ls
      Array.new.tap do |files|
        Find.find(music_path) do |file|
          next if File.directory?(file)
          files << relative_path(file)
        end
      end
    end

    #######
    private
    #######

    def music_path
      config.music_path
    end

    def config
      CONFIG
    end

    def relative_path(absolute_path)
      absolute_path.gsub(/#{music_path}\//,'')
    end

  end
end
