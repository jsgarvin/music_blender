require 'test_helper'

module MusicBlender
  class PlayerTest < MiniTest::Unit::TestCase

    describe Player do
      let(:player) { Player.new }
      let(:mock_stdin) { mock('stdin') }
      let(:mock_stdout) { mock('stdout') }
      let(:mock_stderr) { mock('stderr') }
      let(:mock_wait_thread) { mock('wait_thread') }
      let(:mock_monitor_thread) { mock('monitor_thread') }

      before do
        Open3.expects(:popen3).returns(mock_stdin,mock_stdout,mock_stderr,mock_wait_thread)
        Thread.expects(:new).returns(mock_monitor_thread)
        player.stubs(:config)
      end

      describe 'play' do
        let(:track1) { create(:track) }
        let(:track2) { create(:track) }
        let(:music_folder) { create(:music_folder) }

        before do
          player.stubs(:music_folder).returns(music_folder)
          music_folder.stubs(:pick_a_track).returns(track1)
          mock_stdin.stubs(:puts)
        end

        def test_loads_a_song
          mock_stdin.expects(:puts).with(regexp_matches(/^LOAD #{track1.full_path}/))
          player.play
        end

        def test_sets_last_played_at
          player.stubs(:current_track => track1)
          assert_operator(track1.last_played_at,:<,1.minute.ago)
          player.play
          assert_operator(track1.last_played_at,:>,1.minute.ago)
        end

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

      describe 'delegated methods' do
        let(:mock_monitor) { mock('monitor') }

        before do
          PlayerMonitor.stubs(:new => mock_monitor)
        end

        def test_should_get_status_string
          mock_monitor.expects(:stop_pause_status => 1)
          assert_equal('Paused', player.status_string)
        end

      end

    end
  end
end
