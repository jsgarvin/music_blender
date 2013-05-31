require 'test_helper'

class ConfigurationTest < MiniTest::Unit::TestCase
 
  def test_initialize_configuration
    Configuration.instance.set(music_path: '/path')
    assert_equal('/path',Configuration.instance.music_path)
  end

end
