require 'test_helper'

module MyMusicPlayer
  class BootstrapTest < MiniTest::Unit::TestCase
    attr_reader :bootstrap, :mock_shell

    def setup
      @bootstrap = Bootstrap.new
      @mock_shell = mock('shell')
      Shell.stubs(:new).returns(@mock_shell)
    end

    def test_call
      DbAdapter.any_instance.expects(:spin_up)
      mock_music_folder.expects(:load_new_tracks)
      mock_shell.expects(:run)
      bootstrap.call
    end

    def test_config
      assert_equal(mock_music_folder,bootstrap.send(:music_folder))
    end

  end
end

