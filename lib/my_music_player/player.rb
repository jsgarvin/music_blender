module MyMusicPlayer
  class Player
    include Singleton

    attr_reader :stdin, :stdout, :stderr, :thread

    def initialize
      @stdin, @stdout, @stderr, @music_thread = Open3.popen3('mpg321 -R meaningless_but_required_bogus_argument')
    end

    def play
      #@stdin.puts "LOAD #{pick_a_song}"
      play_music_until_stopped
      Thread.new do
        while playing?
          puts @stdout.readlines
          puts @stderr.readlines
          sleep 1
        end
      end
    end

    def stop
      stdin.puts 'STOP'
    end

    #######
    private
    #######

    def playing?
      @music_thread and @music_thread.alive?
    end

    def play_music_until_stopped
      Thread.new do
        while true
          play_next_song
        end
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
