require 'test_helper'

module MyMusicPlayer
  class TrackTest < MiniTest::Unit::TestCase
    attr_reader :track

    def setup
      @track = create(:track)
    end

    def test_full_path
      assert_kind_of(String,track.full_path)
    end

    describe 'loading title from taglib on create' do
      attr_reader :root_folder

      before do
        @root_folder = create(:root_folder, :path => "#{PLAYER_ROOT}/test/music")
      end

      def test_loads_title_id3_tag
        track = root_folder.tracks.create(:relative_path => 'point1sec.mp3')
        assert_equal('Silent MP3 10th-of-a-sec',track.title)
      end
    end
  end
end
