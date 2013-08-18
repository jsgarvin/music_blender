module MyMusicPlayer
  class Player
    include Singleton

    PLAYING_STATUS_CODE_MAP = {
      -1 => 'Started',
      0 => 'Stopped',
      1 => 'Paused',
      2 => 'Resumed',
      3 => 'Ended'
    }

    attr_reader :stdin, :stdout, :stderr, :playing,
      :stop_pause_status, :song_name, :frames, :frames_remaining,
      :seconds, :seconds_remaining
    alias_method :playing?, :playing

    def initialize
      @stdin, @stdout, @stderr, @wait_thread =
        Open3.popen3('mpg321 -R required_bogus_argument')
      Thread.new { monitor_player_output }
    end

    def play
      stdin.puts "LOAD #{pick_a_song}"
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
      Scanner.instance.ls.sample
    end

    def monitor_player_output
      loop do
        process_stdout_status_line(@stdout.readline) while @stdout.ready?
        # Because some of the output message types (@F, @E) in mpg321 0.3.2
        # seem to be getting erroneously sent to stderr instead of stdout.
        process_stdout_status_line(@stderr.readline) while @stderr.ready?
      end
    end

    def process_stdout_status_line(line)
      process_information_message($1) if line.match(/^@I (.+)/)
      process_stop_pause_status($1.to_i) if line.match(/^@P ([0-3])/)
      process_frame_message($1) if line.match(/@F (.+)/)
    end

    def process_information_message(message)
      @song_name = message
      @stop_pause_status = -1
      @playing = true
    end

    def process_stop_pause_status(status)
      @stop_pause_status = status
      case status
      when 0 then #STOPPED
        @playing = false
      when 1 then #PAUSED
        @playing = false
      when 2 then #RESUMED
        @playing = true
      when 3 then #ENDED
        # Despite documentation to the contrary, this
        # doesn't seem to ever actually occur, so
        # there's the execute_song_ended_hack method
        # to fake it.
        @playing = false
        play
      end
    end

    def process_frame_message(message)
      @frames, @frames_remaining, @seconds, @seconds_remaining =
        message.split(/\s/).map { |value| value.to_f }
      execute_song_ended_hack if @seconds_remaining < 1
    end

    def execute_song_ended_hack
      @stop_pause_status = 3
      @playing = false
      play
    end
  end
end
