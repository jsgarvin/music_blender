require 'test_helper'

module MyMusicPlayer
  class ScannerTest < MiniTest::Unit::TestCase

    def test_should_find_files_in_music_folder
      puts Scanner.instance.ls.inspect
    end
    
  end
end
