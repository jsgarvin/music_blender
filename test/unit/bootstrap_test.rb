require 'test_helper'

module MyMusicPlayer
  class BootstrapTest < MiniTest::Unit::TestCase
    attr_reader :bootstrap, :mock_shell

    def setup
      @bootstrap = Bootstrap.new
      @bootstrap.stubs(:root_folder).returns(mock_root_folder)
      @mock_shell = mock('shell')
      Shell.stubs(:new).returns(@mock_shell)
    end

    def test_call
      DbAdapter.any_instance.expects(:spin_up)
      mock_root_folder.expects(:load_new_tracks)
      mock_shell.expects(:run)
      bootstrap.call
    end

    def test_config
      bootstrap.unstub(:root_folder)
      assert_equal(ROOT_FOLDER,bootstrap.send(:root_folder))
    end

  end
end

