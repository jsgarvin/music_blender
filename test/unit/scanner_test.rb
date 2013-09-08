require 'test_helper'

module MyMusicPlayer
  class ScannerTest < MiniTest::Unit::TestCase
    attr_reader :scanner

    def setup
      @scanner = Scanner.new
    end

    def test_should_find_files_in_music_folder
      files = scanner.ls
      assert files.include?('point1sec.mp3')
      assert files.include?('subfolder/insubfolder.mp3')
    end

    def test_config
      Scanner.any_instance.unstub(:config)
      assert_equal(CONFIG,scanner.send(:config))
    end

  end
end
