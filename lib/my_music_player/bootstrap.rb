module MyMusicPlayer
  class Bootstrap

    def call
      load_new_tracks
      launch_shell
    end

    #######
    private
    #######

    def load_new_tracks
      Scanner.new.ls.each do |relative_path|
        config.root_folder.tracks.find_or_create_by(:relative_path => relative_path)
      end
    end

    def launch_shell
      MyMusicPlayer::Shell.new.run(*ARGV)
    end

    def config
      MyMusicPlayer::CONFIG
    end

  end
end
