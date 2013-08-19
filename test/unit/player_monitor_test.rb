require 'test_helper'
require 'tempfile'

module MyMusicPlayer
  class PlayerMonitorTest < MiniTest::Unit::TestCase

    def setup
      mock_stdout_readable, @mock_stdout_writeable = IO.pipe
      mock_stderr_readable, @mock_stderr_writeable = IO.pipe
      mock_player = mock('player')
      mock_player.stubs(:stdout).returns(mock_stdout_readable)
      mock_player.stubs(:stderr).returns(mock_stderr_readable)
      @monitor = PlayerMonitor.new(mock_player)
      @thread = Thread.new { @monitor.run }
    end

    def teardown
      @thread.exit
    end

    def test_should_read_from_stdout
      assert_equal(nil,@monitor.song_name)
      @mock_stdout_writeable.write('@I Foobar')
      @mock_stdout_writeable.close
      sleep 1
      assert_equal('Foobar',@monitor.song_name)
    end

  end
end
