require 'test_helper'

module MyMusicPlayer
  class TrackTest < MiniTest::Unit::TestCase
    attr_reader :track

    def setup
      Track.any_instance.stubs(:rating_frame => OpenStruct.new(:text => '5'))
      @mock_id3_tag = mock('tag')
      @mock_id3_tag.stubs(:title => 'Foo', :artist => 'Bar')
      Track.any_instance.stubs(:id3_tag => @mock_id3_tag)
      @track = create(:track)
    end

    def test_full_path
      assert_kind_of(String,track.full_path)
    end


    describe 'except_recently_played scope' do
      attr_reader :track1, :track2, :track3

      before do
        @track1 = create(:track, :last_played_at => 3.days.ago)
        @track2 = create(:track, :last_played_at => 2.days.ago)
        @track3 = create(:track, :last_played_at => 1.days.ago)
      end

      def test_does_not_include_recently_played
        assert_includes(Track.except_recently_played,track1)
        track1.update_column(:last_played_at, Time.now)
        refute_includes(Track.except_recently_played,track1)
      end

      describe 'most_recent scope' do

        def test_gets_most_recent_2_tracks
          refute_includes(Track.most_recent(2),track1)
          track1.update_column(:last_played_at, Time.now)
          assert_includes(Track.most_recent(2),track1)
        end

      end

    end

    describe 'loading attributes from taglib on create' do
      attr_reader :music_folder

      before do
        @music_folder = create(:music_folder, :path => "#{PLAYER_ROOT}/test/music")
      end

      describe 'loading artist' do

        def test_loads_and_creates_artist
          assert_difference('Artist.count') do
            track = music_folder.tracks.create(:relative_path => 'point1sec.mp3')
            assert_equal('DefBeats',track.artist.name)
          end
        end

      end

      describe 'loading title' do

        def test_loads_title_id3_tag
          track = music_folder.tracks.create(:relative_path => 'point1sec.mp3')
          assert_equal('Silent MP3 10th-of-a-sec',track.title)
        end

      end
    end

    describe 'saving rating to id3 tag on update' do
      before do
        Track.any_instance.unstub(:persist_rating_to_id3_tag)
        Track.any_instance.unstub(:rating_frame)
        @mock_id3_tag = mock('tag')
        @mock_id3_tag.stubs(:title => 'Foo', :artist => 'Bar')
        @mock_id3_tag_file = mock('tag_file')
        @mock_id3_tag_file.stubs(:id3v2_tag => @mock_id3_tag)
        @mock_id3_tag_file.stubs(:save)
        @mock_rating_frame = mock('rating_frame')
        @mock_rating_frame.stubs(:text => '3')
        @mock_rating_frame.stubs(:text=)
        Track.any_instance.stubs(:rating_frame => @mock_rating_frame)
        Track.any_instance.stubs(:id3_tag_file => @mock_id3_tag_file)
        @track = create(:track)
      end

      def test_saves_rating_to_id3_tag
        @mock_rating_frame.expects('text=').with('42')
        @mock_id3_tag_file.expects(:save)
        @track.update_attribute(:rating,42)
      end
    end
  end
end
