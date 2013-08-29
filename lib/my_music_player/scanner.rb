module MyMusicPlayer
  class Scanner

    def ls
      Array.new.tap do |files|
        Dir["#{music_path}/**/*.mp3"].each do |file_path|
          files << relative_path(file_path)
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
