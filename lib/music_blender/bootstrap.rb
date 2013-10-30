module MusicBlender
  class Bootstrap

    def call
      spin_up_db
      update_tracks
      launch_shell
    end

    #######
    private
    #######

    def spin_up_db
      DbAdapter.new.spin_up
    end

    def update_tracks
      music_folder.load_tracks
      music_folder.update_missing_flags
    end

    def launch_shell
      puts catch(:exited) { Shell.new.run(*ARGV) }
    end

    def music_folder
      MusicFolder.current
    end

  end
end
