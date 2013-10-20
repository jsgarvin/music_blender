module MyMusicPlayer
  class Player

    PLAYING_STATUS_CODE_MAP = {
      -1 => 'Started',
      0 => 'Stopped',
      1 => 'Paused',
      2 => 'Resumed',
    }

    METHODS_DELEGATED_TO_MONITOR = [
      :frames,
      :frames_remaining,
      :playing,
      :seconds,
      :seconds_remaining,
      :song_name,
      :stop_pause_status
    ]

    attr_reader :current_track, :logger, :stdin, :stdout, :stderr

    METHODS_DELEGATED_TO_MONITOR.each do |delegated_method_name|
      define_method(delegated_method_name) do
        monitor.send(delegated_method_name)
      end
    end

    def initialize
      @stdin, @stdout, @stderr, @wait_thread =
        Open3.popen3('mpg123 --rva-mix -R')
      @logger = Logger.new("#{PLAYER_ROOT}/log/player.log",'daily')
      Thread.new { monitor.run }
    end

    def play
      set_current_track_last_played_at
      stdin.puts "LOAD #{pick_a_track.full_path}"
    end

    def pause
      stdin.puts 'PAUSE'
    end

    def stop
      stdin.puts 'STOP'
    end

    def quit
      stdin.puts 'QUIT'
    end

    def status_string
      PLAYING_STATUS_CODE_MAP[stop_pause_status]
    end

    #######
    private
    #######

    def set_current_track_last_played_at
      if current_track
        current_track.update_column(:last_played_at, Time.now)
      end
    end

    def pick_a_track
      music_folder.pick_a_track.tap do |track|
        @current_track = track
        logger.debug("Picked Next Track: #{track.id} - #{track.full_path}")
      end
    end

    def monitor
      @monitor ||= PlayerMonitor.new(self)
    end

    def music_folder
      MusicFolder.current
    end

  end
end
