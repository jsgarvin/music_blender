require 'test_helper'
require 'ostruct'

module MyMusicPlayer
  class RootFolderTest < MiniTest::Unit::TestCase
    attr_reader :root_folder

    def setup
      Track.any_instance.stubs(:rating_frame => OpenStruct.new(:text => '5'))
      @root_folder = create(:root_folder_with_tracks)
    end

    def test_pick_a_track
      assert(root_folder.tracks.include?(root_folder.pick_a_track))
    end

    def test_load_new_tracks
      Track.any_instance.stubs(:id3_tag => OpenStruct.new(:title => 'x'))
      root_folder.stubs(:relative_paths => ['a','b','c'])
      create(:track, :root_folder => root_folder, :relative_path => 'a')
      release_stdout
      assert_difference('Track.count' => 2) do
        root_folder.load_new_tracks
      end
    end
  end
end

