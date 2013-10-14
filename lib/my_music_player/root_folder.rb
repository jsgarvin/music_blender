module MyMusicPlayer
  class RootFolder < ActiveRecord::Base
    has_many :tracks

    class << self
      def current
        @current ||= RootFolder.find_or_create_by(path: MUSIC_PATH)
      end
    end

    def pick_a_track
      tracks.sample
    end

    def load_new_tracks
      relative_paths.each do |relative_path|
        tracks.find_or_create_by(:relative_path => relative_path)
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
