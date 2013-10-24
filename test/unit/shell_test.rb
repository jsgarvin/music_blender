require 'test_helper'

module MyMusicPlayer
  class ShellTest < MiniTest::Unit::TestCase
    attr_reader :mock_player, :mock_scanner

    describe Shell do
      let(:mock_player) { mock('player') }
      let(:shell) { Shell.new }

      before do
        mock_player.stubs(:stop)
        mock_player.stubs(:quit)
        Shell.stubs(:player).returns(mock_player)
      end

      def test_gracefully_fail_to_execute_command
        assert_equal('',$stdout.string)
        run_shell(:ping)
        assert_match(/Unrecognized Command: ping/,$stdout.string)
      end

      describe 'info' do
        before do
          Shell.expects(:print_info)
        end

        def test_execute_info
          assert_equal('',$stdout.string)
          run_shell(:info)
          refute_equal('',$stdout.string)
        end
      end

      describe 'player commands' do
        def test_execute_player_commands
          [:play,:stop,:quit].each do |command|
            mock_player.expects(command)
            run_shell(command)
          end
        end
      end

      describe 'commands with arguments' do
        let(:track) { create(:track) }

        before do
          mock_player.stubs(:current_track => track)
        end

        def test_executes_command_with_arguments
          assert_equal('',$stdout.string)
          assert_difference('track.rating' => -31) do
            run_shell('rate 11')
          end
          assert_match(/Rating Updated To: 11/,$stdout.string)
        end
      end

      #######
      private
      #######

      def run_shell(command)
        assert_throws(:exited) { shell.run(command.to_s) }
        #shell.run(command.to_s)
      end

    end
  end
end
