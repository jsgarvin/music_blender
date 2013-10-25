require 'test_helper'

module MyMusicPlayer
  class BootstrapTest < MiniTest::Unit::TestCase
    attr_reader :bootstrap, :mock_shell

    describe Bootstrap do
      let(:bootstrap) { Bootstrap.new }
      let(:mock_shell) { mock('shell')}
      let(:mock_music_folder) { mock('music_folder') }

      before do
        Shell.stubs(:new).returns(mock_shell)
        MusicFolder.stubs(:current).returns(mock_music_folder)
      end

      def test_call
        DbAdapter.any_instance.expects(:spin_up)
        mock_music_folder.expects(:load_tracks)
        mock_music_folder.expects(:update_missing_flags)
        mock_shell.expects(:run).throws(:exited)
        bootstrap.call
      end

      def test_config
        assert_equal(mock_music_folder,bootstrap.send(:music_folder))
      end

    end
  end
end

