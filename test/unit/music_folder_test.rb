require 'test_helper'
require 'ostruct'

module MyMusicPlayer
  class MusicFolderTest < MiniTest::Unit::TestCase
    attr_reader :music_folder

    def setup
      Track.any_instance.stubs(:rating_frame => OpenStruct.new(:text => '5'))
      @mock_id3_tag = mock('tag')
      @mock_id3_tag.stubs(:title => 'Foo', :artist => 'Bar')
      Track.any_instance.stubs(:id3_tag => @mock_id3_tag)
      @music_folder = create(:music_folder_with_tracks)
    end

    def test_pick_a_track
      assert_includes(music_folder.tracks,music_folder.pick_a_track)
    end

    def test_load_new_tracks
      Track.any_instance.stubs(:id3_tag => OpenStruct.new(:title => 'foo', :artist => 'bar'))
      music_folder.stubs(:relative_paths => ['a','b','c'])
      create(:track, :music_folder => music_folder, :relative_path => 'a')
      assert_difference('Track.count' => 2) do
        music_folder.load_new_tracks
      end
    end
  end
end

