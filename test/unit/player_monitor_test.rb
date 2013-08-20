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

    def test_should_process_i_messages
      assert_equal(nil,@monitor.song_name)
      @mock_stdout_writeable.write('@I Foobar')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal('Foobar',@monitor.song_name)
    end

    def test_should_process_f_messages
      @mock_stdout_writeable.write('@F 1 2 3 4')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal(1,@monitor.frames)
      assert_equal(2,@monitor.frames_remaining)
      assert_equal(3,@monitor.seconds)
      assert_equal(4,@monitor.seconds_remaining)
    end

    def test_should_process_p_stop_messages
      @mock_stdout_writeable.write('@P 0')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal(0,@monitor.stop_pause_status)
      assert_equal(false,@monitor.playing)
    end

    def test_should_process_p_paused_messages
      @mock_stdout_writeable.write('@P 1')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal(1,@monitor.stop_pause_status)
      assert_equal(false,@monitor.playing)
    end

    def test_should_process_p_resumed_messages
      @mock_stdout_writeable.write('@P 2')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal(2,@monitor.stop_pause_status)
      assert_equal(true,@monitor.playing)
    end

    def test_should_process_p_ended_messages
      @monitor.player.expects(:play)
      @mock_stdout_writeable.write('@P 3')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal(3,@monitor.stop_pause_status)
      assert_equal(false,@monitor.playing)
    end

    def test_should_execute_song_ended_hack
      @monitor.player.expects(:play)
      @mock_stdout_writeable.write('@F 100 2 30 0.9')
      @mock_stdout_writeable.close
      sleep 0.1
      assert_equal(3,@monitor.stop_pause_status)
      assert_equal(false,@monitor.playing)
    end

  end
end
