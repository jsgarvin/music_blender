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
      Player.instance.stop
      Player.instance.quit
      puts "Exiting..."
    end

    def _mmp_ls
      Scanner.instance.ls.each do |file|
        puts file
      end
    end

    def _mmp_play
      Player.instance.play
    end

    def _mmp_pause
      Player.instance.pause
    end

    def _mmp_stop
      Player.instance.stop
    end

    def _mmp_info
      puts Player.instance.song_name
      puts Player.instance.status_string
      puts "Seconds: #{Player.instance.seconds} (#{Player.instance.seconds_remaining})"
    end
  end
end
