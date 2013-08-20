module MyMusicPlayer
  class PlayerMonitor
    attr_accessor :frames, :frames_remaining, :player, :playing, :seconds, :seconds_remaining,
      :song_name, :stop_pause_status

    def initialize(player)
      @player = player
    end

    def run
      loop do
        process_output_line(stdout.readline) while stdout.ready?
        # Because some of the output message types (@F, @E) in mpg321 v0.3.2
        # seem to be getting erroneously sent to stderr instead of stdout.
        process_output_line(stderr.readline) while stderr.ready?
        sleep 0.001
      end
    end

    #######
    private
    #######

    def stdout
      player.stdout
    end

    def stderr
      player.stderr
    end

    def process_output_line(line)
      if line.match(/^@F (.+)/)
        process_frame_message($1)
      elsif line.match(/^@I (.+)/)
        process_information_message($1)
      elsif line.match(/^@P ([0-3])/)
        process_stop_pause_status($1.to_i)
      end
    end

    def process_frame_message(message)
      self.frames, self.frames_remaining, self.seconds, self.seconds_remaining =
        message.split(/\s/).map { |value| value.to_f }
      execute_song_ended_hack if seconds_remaining < 1
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
        # doesn't seem to ever actually occur IRL, so
        # there's the execute_song_ended_hack method
        # to fake it.
        @playing = false
        play
      end
    end

    def execute_song_ended_hack
      @stop_pause_status = 3
      @playing = false
      play
    end

    def play
      player.play
    end

  end
end
