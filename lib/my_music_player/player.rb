module MyMusicPlayer
  class Player

    PLAYING_STATUS_CODE_MAP = {
      -1 => 'Started',
      0 => 'Stopped',
      1 => 'Paused',
      2 => 'Resumed',
      3 => 'Ended'
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

    attr_reader :stdin, :stdout, :stderr

    METHODS_DELEGATED_TO_MONITOR.each do |delegated_method_name|
      define_method(delegated_method_name) do
        monitor.send(delegated_method_name)
      end
    end

    def initialize
      @stdin, @stdout, @stderr, @wait_thread =
        Open3.popen3('mpg123 -R required_bogus_argument')
      Thread.new { monitor.run }
    end

    def play
      stdin.puts "LOAD #{pick_a_song.full_path}"
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

    def pick_a_song
      CONFIG.root_folder.tracks.sample
    end

    def monitor
      @monitor ||= PlayerMonitor.new(self)
    end

  end
end
