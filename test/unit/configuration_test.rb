require 'test_helper'

module MyMusicPlayer
  class ConfigurationTest < MiniTest::Unit::TestCase

    def test_initialize_configuration
      @config = Configuration.new(music_path: '/path')
      assert_equal('/path',@config.music_path)
    end

  end
end
