require 'test_helper'

module MyMusicPlayer
  class RootFolderTest < MiniTest::Unit::TestCase
    attr_reader :root_folder

    def setup
      @root_folder = create(:root_folder_with_tracks)
    end

    def test_pick_a_track
      assert(root_folder.tracks.include?(root_folder.pick_a_track))
    end
  end
end

