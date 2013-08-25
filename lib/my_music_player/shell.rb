module MyMusicPlayer
  class Shell

    def run(*commands)
      commands << :exit unless commands.empty?
      command = nil
      until command.to_s == 'exit'
        print 'mmp> '
        command = commands.shift || gets.strip
        if self.respond_to?("_mmp_#{command}")
          send("_mmp_#{command}")
        else
          puts "Unrecognized Command: #{command}"
        end
      end
    end

    def _mmp_exit
      player.stop
      player.quit
      puts "Exiting..."
    end

    def _mmp_ls
      scanner.ls.each do |file|
        puts file
      end
    end

    def _mmp_play
      player.play
    end

    def _mmp_pause
      player.pause
    end

    def _mmp_stop
      player.stop
    end

    def _mmp_info
      puts player.song_name
      puts player.status_string
      puts "Seconds: #{player.seconds} (#{player.seconds_remaining})"
    end

    #######
    private
    #######

    def scanner
      @scanner ||= Scanner.new
    end

    def player
      @player ||= Player.new
    end
  end
end
