require 'test_helper'

module MyMusicPlayer
  class TrackTest < MiniTest::Unit::TestCase

    describe Track do
      let(:track) { create(:track) }
      let(:mock_id3_tag) { mock('tag') }

      def setup
        Track.any_instance.stubs(:rating_frame => OpenStruct.new(:text => '5'))
        mock_id3_tag.stubs(:title => 'Foo', :artist => 'Bar')
        Track.any_instance.stubs(:id3v2_tag => mock_id3_tag)
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
    end
  end
end
