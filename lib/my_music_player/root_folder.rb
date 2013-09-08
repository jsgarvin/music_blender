module MyMusicPlayer
  class RootFolder < ActiveRecord::Base
    has_many :tracks

    def pick_a_track
      tracks.sample
    end
  end
end
