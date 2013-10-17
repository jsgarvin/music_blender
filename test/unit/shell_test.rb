require 'test_helper'

module MyMusicPlayer
  class ShellTest < MiniTest::Unit::TestCase
    attr_reader :mock_player, :mock_scanner

    def setup
      @mock_player = mock('player')
      @mock_player.expects(:stop)
      @mock_player.expects(:quit)
      Player.stubs(:new).returns(@mock_player)
    end

    def test_execute_a_command_and_exit
      Shell.any_instance.expects(:_mmp_foobar)
      assert_equal('',$stdout.string)
      Shell.new.run(:foobar)
      assert_match(/Exiting/,$stdout.string)
    end

    def test_gracefully_fail_to_execute_command
      assert_equal('',$stdout.string)
      Shell.new.run(:ping)
      assert_match(/Unrecognized Command: ping/,$stdout.string)
    end

    def test_execute_info
      #TODO: way too much mocking in here. find a better way.
      mock_track = mock('track')
      mock_track.expects(:title => 'Foobar', :full_path => '/some/path', :artist => OpenStruct.new(:name => 'Foobar'), :rating => 4)
      mock_player.stubs(:current_track => mock_track)
      mock_player.expects(:seconds)
      mock_player.expects(:seconds_remaining)
      assert_equal('',$stdout.string)
      Shell.new.run(:info)
      refute_equal('',$stdout.string)
    end

    [:play,:pause,:stop].each do |command_name|
      define_method("test_execute_#{command_name}") do
        mock_player.expects(command_name)
        Shell.new.run(command_name)
      end
    end

  end
end
