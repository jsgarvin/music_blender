module MyMusicPlayer
  class Player
    include Singleton

    attr_reader :music_thread

    def play
      @music_thread ||= Thread.new do
        play_music_until_stopped
      end      
    end
    
    def stop
      @music_thread.exit if playing?
    end

    #######
    private
    #######
    
    def playing?
      @music_thread and @music_thread.alive?
    end

    def play_music_until_stopped
      while true
        play_next_song
      end
    end

    def play_next_song
      `mpg321 -q '#{pick_a_song}'`
    end

    def pick_a_song
      Scanner.instance.ls.sample
    end
  end
end
