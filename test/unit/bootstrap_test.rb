require 'test_helper'

module MyMusicPlayer
  class BootstrapTest < MiniTest::Unit::TestCase
    attr_reader :bootstrap, :mock_config, :mock_shell

    def setup
      @bootstrap = Bootstrap.new
      @mock_config = mock('config')
      @bootstrap.stubs(:config).returns(@mock_config)
      @mock_shell = mock('shell')
      Shell.stubs(:new).returns(@mock_shell)
    end

    def test_call
      DbAdapter.any_instance.expects(:spin_up)
      Scanner.any_instance.expects(:ls).returns([1])
      mock_root_folder = mock('root_folder')
      mock_config.expects(:root_folder).returns(mock_root_folder)
      mock_root_folder.expects(:load_new_tracks)
      mock_shell.expects(:run)
      bootstrap.call
    end

    def test_config
      bootstrap.unstub(:config)
      assert_equal(CONFIG,bootstrap.send(:config))
    end

  end
end

