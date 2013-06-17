require 'test_helper'

module MyMusicPlayer
  class ScannerTest < MiniTest::Unit::TestCase

    def test_should_find_files_in_music_folder
      assert Scanner.instance.ls.include?(File.expand_path('../../music/point1sec.mp3', __FILE__))
    end
    
  end
end
