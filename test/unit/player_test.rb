require 'test_helper'

module MyMusicPlayer
  class PlayerTest < MiniTest::Unit::TestCase

    def setup
      @player = Player.instance
    end

    def test_should_create_running_thread
      begin
        assert_equal(nil, @player.music_thread)
        @player.play
        assert_kind_of(Thread,@player.music_thread)
        assert(@player.music_thread.alive?)
      ensure
        @player.music_thread.exit
      end
    end
  end
end
