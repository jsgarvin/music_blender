require 'test_helper'

module MusicBlender
  class ArtistTest < MiniTest::Unit::TestCase
    def test_instantiation
      assert_kind_of(Artist,create(:artist))
    end
  end
end
