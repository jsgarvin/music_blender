module MyMusicPlayer
  class RootFolder < ActiveRecord::Base
    has_many :tracks

    def pick_a_track
      tracks.sample
    end

    def load_new_tracks(relative_paths)
      relative_paths.each do |relative_path|
        tracks.find_or_create_by(:relative_path => relative_path)
      end
    end
  end
end
