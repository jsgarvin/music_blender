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
      puts player.current_track.full_path
      puts player.current_track.title
      puts player.current_track.artist.name
      puts "Rating: #{player.current_track.rating}"
      puts "Last Played: #{player.current_track.last_played_at}"
      puts "Seconds: #{player.seconds} (#{player.seconds_remaining})"
    end

#    def _mmp_import_scores
#      require 'nokogiri'
#      require 'uri'
#      Track.update_all(:rating => nil)
#      doc = Nokogiri::XML(File.open(File.expand_path('~/.local/share/rhythmbox/rhythmdb.xml')))
#      doc.css("entry[type='song']").each do |song_data|
#        relative_path = URI.unescape(song_data.at_css('location').content.gsub(/.+music\//,''))
#        score = song_data.at_css('rating').try(:content).to_i
#        track = Track.find_by(:relative_path => relative_path)
#        if track
#          track.update_column(:rating, score*2) if track.rating.to_i < score
#        end
#      end
#    end

    #######
    private
    #######

    def player
      @player ||= Player.new
    end
  end
end
