require 'test_helper'

module MyMusicPlayer
  class PlayerTest < MiniTest::Unit::TestCase

    def setup
      @mock_stdin ||= mock('stdin')
      @mock_stdout ||= mock('stdout')
      @mock_stderr ||= mock('stderr')
      @mock_wait_thread ||= mock('wait_thread')
      @mock_monitor_thread ||= mock('monitor_thread')
      Open3.expects(:popen3).returns(@mock_stdin,@mock_stdout,@mock_stderr,@mock_wait_thread)
      Thread.expects(:new).returns(@mock_monitor_thread)
      Singleton.__init__(Player)
      @player = Player.instance
    end

    def test_should_load_a_song
      @mock_stdin.expects(:puts).with(regexp_matches(/^LOAD /))
      @player.play
    end

    def test_should_pause
      @mock_stdin.expects(:puts).with('PAUSE')
      @player.pause
    end

    def test_should_stop
      @mock_stdin.expects(:puts).with('STOP')
      @player.stop
    end

    def test_should_quit
      @mock_stdin.expects(:puts).with('QUIT')
      @player.quit
    end

    def test_should_exercise_a_delegated_method
      mock_monitor = mock('monitor')
      mock_monitor.expects(:song_name)
      PlayerMonitor.stubs(:new => mock_monitor)
      @player.song_name
    end

    def test_should_get_status_string
      mock_monitor = mock('monitor')
      mock_monitor.expects(:stop_pause_status => 1)
      PlayerMonitor.stubs(:new => mock_monitor)
      assert_equal('Paused', @player.status_string)
    end

  end
end
