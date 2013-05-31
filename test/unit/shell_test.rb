require 'test_helper'

module MyMusicPlayer
  class ShellTest < MiniTest::Unit::TestCase

    def test_execute_a_command_and_exit
      Shell.instance.expects(:_mmp_ping)
      assert_equal('',$stdout.string)
      Shell.instance.run(:ping)
      assert_match(/Exiting/,$stdout.string)
    end

    def test_gracefully_fail_to_execute_command
      assert_equal('',$stdout.string)
      Shell.instance.run(:ping)
      assert_match(/Unrecognized Command: ping/,$stdout.string)
    end

  end
end
