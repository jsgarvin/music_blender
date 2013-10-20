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
        play_next_track if seconds_remaining < 1
      when 1 then #PAUSED
        @playing = false
      when 2 then #RESUMED
        @playing = true
      end
    end

    def play_next_track
      player.play
    end

  end
end
