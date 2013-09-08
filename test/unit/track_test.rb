require 'test_helper'

module MyMusicPlayer
  class TrackTest < MiniTest::Unit::TestCase
    attr_reader :mock_file, :track

    def setup
      @track = create(:track)
    end

    def test_full_path
      assert_kind_of(String,track.full_path)
      assert_equal(mock_id3_tag.title, track.title)
    end

  end
end
