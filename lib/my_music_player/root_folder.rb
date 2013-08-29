module MyMusicPlayer
  class RootFolder < ActiveRecord::Base
    has_many :tracks

  end
end
