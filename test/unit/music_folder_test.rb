require 'test_helper'
require 'ostruct'

module MyMusicPlayer
  class MusicFolderTest < MiniTest::Unit::TestCase

    describe MusicFolder do
      let(:music_folder) { create(:music_folder_with_tracks) }
      let(:mock_id3_tag) { mock('tag') }

      before do
        Track.any_instance.stubs(:rating_frame => OpenStruct.new(:text => '5'))
        mock_id3_tag.stubs(:title => 'Foo', :artist => 'Bar')
        Track.any_instance.stubs(:import_id3_tag_attributes)
      end

      def test_pick_a_track
        assert_includes(music_folder.tracks,music_folder.pick_a_track)
      end

      describe 'loading new tracks' do

        before do
          Track.any_instance.unstub(:import_id3_tag_attributes)
          create(:track, :music_folder => music_folder, :relative_path => 'a')
          music_folder.stubs(:relative_paths => ['a','b','c'])
        end

        def test_load_new_tracks
          assert_difference('Track.count' => 2) do
            music_folder.load_new_tracks
          end
        end

      end

      describe 'music_path' do

        def test_uses_constant
          assert_equal(MUSIC_PATH, MusicFolder.music_path)
        end

      end

      describe 'current' do

        before do
          MusicFolder.instance_variable_set(:@current, nil)
        end

        describe 'when one does not already exist' do

          before do
            MusicFolder.stubs(:music_path).returns('/some/non/existent/path/dsedfget')
          end

          def test_create_music_folder
            assert_difference('MusicFolder.count') do
              MusicFolder.current
            end
          end

        end

        describe 'when one does already exist' do
          let(:music_folder) { create(:music_folder) }

          before do
            MusicFolder.stubs(:music_path).returns(music_folder.path)
          end

          def test_fetch_current_music_folder
            assert_difference('MusicFolder.count' => 0) do
              MusicFolder.current
            end
          end
        end
      end
    end
  end
end

