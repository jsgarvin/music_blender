module MyMusicPlayer
  class Bootstrap

    def call
      spin_up_db
      load_new_tracks
      launch_shell
    end

    #######
    private
    #######

    def spin_up_db
      DbAdapter.new.spin_up
    end

    def load_new_tracks
      music_folder.load_new_tracks
    end

    def launch_shell
      puts catch(:exited) { Shell.new.run(*ARGV) }
    end

    def music_folder
      MusicFolder.current
    end

  end
end
