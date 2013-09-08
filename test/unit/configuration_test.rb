require 'test_helper'

module MyMusicPlayer
  class ConfigurationTest < MiniTest::Unit::TestCase
    attr_reader :config

    def setup
      @config = Configuration.new(music_path: '/path')
    end

    def test_initialize_configuration
      assert_equal('/path',@config.music_path)
    end

    def test_root_folder
      RootFolder.expects(:find_or_create_by).with(:path => config.music_path)
      config.root_folder
    end

  end
end
