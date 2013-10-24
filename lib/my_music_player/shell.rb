module MyMusicPlayer
  class Shell

    COMMANDS = {
      exit: ->() { player.stop; player.quit; throw(:exited, 'Exited Successfully'); },
      info: ->() { print_info }
    }.with_indifferent_access

    def run(*commands)
      commands << :exit unless commands.empty?
      print 'mmp> '
      (commands.shift || gets.strip).tap do |command|
        execute(command)
        run(*commands)
      end
    end

    #######
    private
    #######

    def self.player
      @player ||= Player.new
    end

    def self.print_info
      puts player.current_track.full_path
      puts player.current_track.title
      puts player.current_track.artist.name
      puts "Rating: #{player.current_track.rating}"
      puts "Last Played: #{player.current_track.last_played_at}"
      puts "Seconds: #{player.seconds} (#{player.seconds_remaining})"
    end

    def execute(command)
      if player.respond_to?(command)
        player.send(command)
      elsif COMMANDS.has_key?(command)
        COMMANDS[command].call
      else
        puts "Unrecognized Command: #{command}"
      end
    end

    def player
      self.class.player
    end
  end
end
