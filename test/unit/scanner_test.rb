require 'test_helper'

module MyMusicPlayer
  class ScannerTest < MiniTest::Unit::TestCase

    def test_should_find_files_in_music_folder
      assert Scanner.instance.ls.include?('point1sec.mp3')
      assert Scanner.instance.ls.include?('subfolder/insubfolder.mp3')
    end
    
  end
end
