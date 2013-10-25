require 'test_helper'

module MyMusicPlayer
  class Id3AdapterTest < MiniTest::Unit::TestCase

    describe Id3Adapter do
      let(:path) { "#{MUSIC_PATH}/point1sec.mp3" }
      let(:adapter) { Id3Adapter.new(path,nil) }

      describe 'loading data' do

        def test_loads_artist
          assert_equal('DefBeats', adapter.artist)
        end

        def test_loads_title
          assert_equal('Silent MP3 10th-of-a-sec', adapter.title)
        end

        def test_loads_rating
          assert_equal(1, adapter.rating)
        end
      end

      describe 'setting data' do

        def test_sets_rating
          assert_difference('adapter.rating' => 41) do
            adapter.set_rating(42)
          end
        ensure
          adapter.send(:v2tag).remove_frame(adapter.send(:rating_frame))
          adapter.send(:tag_file).save
        end

      end

    end

  end
end

