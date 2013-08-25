require 'test_helper'

module MyMusicPlayer
  class ScannerTest < MiniTest::Unit::TestCase

    def test_should_find_files_in_music_folder
      files = Scanner.new.ls
      assert files.include?('point1sec.mp3')
      assert files.include?('subfolder/insubfolder.mp3')
    end

  end
end
