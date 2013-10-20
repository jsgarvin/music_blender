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

    describe 'info' do
      let(:track) { create(:track) }
      let(:player) { Player.new }

      before do
        Shell.any_instance.stubs(:player => player)
        player.stubs(:current_track => track)
      end

      def test_execute_info
        assert_equal('',$stdout.string)
        Shell.new.run(:info)
        refute_equal('',$stdout.string)
      end
    end

    [:play,:pause,:stop].each do |command_name|
      define_method("test_execute_#{command_name}") do
        mock_player.expects(command_name)
        Shell.new.run(command_name)
      end
    end

  end
end
