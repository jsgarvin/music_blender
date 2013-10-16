require 'test_helper'

module MyMusicPlayer
  class PlayerTest < MiniTest::Unit::TestCase
    attr_reader :mock_stdin, :player

    def setup
      @mock_stdin = mock('stdin')
      mock_stdout = mock('stdout')
      mock_stderr = mock('stderr')
      mock_wait_thread = mock('wait_thread')
      Open3.expects(:popen3).returns(mock_stdin,mock_stdout,mock_stderr,mock_wait_thread)

      mock_monitor_thread = mock('monitor_thread')
      Thread.expects(:new).returns(mock_monitor_thread)

      @player = Player.new
      @player.stubs(:config).returns(mock_config)
    end

    def test_should_load_a_song
      mock_track = mock('track')
      mock_music_folder = mock('music_folder')
      mock_music_folder.expects(:pick_a_track).returns(mock_track)
      mock_track.expects(:full_path).returns('/full/path')
      player.expects(:music_folder).returns(mock_music_folder)
      mock_stdin.expects(:puts).with(regexp_matches(/^LOAD \/full\/path/))

      player.play
    end

    def test_should_pause
      mock_stdin.expects(:puts).with('PAUSE')
      player.pause
    end

    def test_should_stop
      mock_stdin.expects(:puts).with('STOP')
      player.stop
    end

    def test_should_quit
      mock_stdin.expects(:puts).with('QUIT')
      player.quit
    end

    def test_should_exercise_a_delegated_method
      mock_monitor = mock('monitor')
      mock_monitor.expects(:song_name)
      PlayerMonitor.stubs(:new => mock_monitor)
      player.song_name
    end

    def test_should_get_status_string
      mock_monitor = mock('monitor')
      mock_monitor.expects(:stop_pause_status => 1)
      PlayerMonitor.stubs(:new => mock_monitor)
      assert_equal('Paused', player.status_string)
    end

    def test_config
      assert_equal(mock_music_folder,player.send(:music_folder))
    end

  end
end
