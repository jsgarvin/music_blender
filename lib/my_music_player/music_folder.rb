module MyMusicPlayer
  class MusicFolder < ActiveRecord::Base
    has_many :tracks

    def self.current
      @current ||= MusicFolder.find_or_create_by(path: music_path)
    end

    def self.music_path
      MUSIC_PATH
    end

    def pick_a_track
      tracks.
        except_recently_played.
        except_by_recently_played_artists.
        by_weighted_random.
        last
    end

    def load_new_tracks
      relative_paths.each do |relative_path|
        track = tracks.find_or_create_by(:relative_path => relative_path)
        track.import_id3_tag_attributes!
      end
    end

    #######
    private
    #######

    def relative_paths
      Array.new.tap do |files|
        Dir["#{path}/**/*.mp3"].each do |file_path|
          files << relative_path(file_path)
        end
      end
    end

    def relative_path(absolute_path)
      absolute_path.gsub(/#{self.path}\//,'')
    end
  end
end
