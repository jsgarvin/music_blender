require 'test_helper'

module MyMediaPlayer
  class ShellTest < MiniTest::Unit::TestCase

    def test_execute_a_command_and_exit
      Shell.instance.expects(:mmp_ping)
      Shell.instance.expects(:mmp_exit)
      Shell.instance.run(:ping)
    end

    def test_gracefully_fail_to_execute_command
      assert_equal('',$stdout.string)
      Shell.instance.run(:ping)
      assert_match(/Unrecognized Command: ping/,$stdout.string)
    end

  end
end
