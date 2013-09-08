require 'rubygems'
require 'bundler/setup'
require 'simplecov'
#require 'fakefs/safe'
require 'minitest/autorun'
require 'factory_girl'
require 'etc'
require 'pry'

SimpleCov.start

require 'my_music_player'

FactoryGirl.find_definitions
module MyMusicPlayer
  CONFIG = 'mock_config'

  class MiniTest::Unit::TestCase
    include FactoryGirl::Syntax::Methods

    attr_reader :mock_id3_tag

    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
    silence_stream(STDOUT)  { load("#{PLAYER_ROOT}/db/schema.rb") }

    def before_setup
      super
      initialize_environment
      capture_stdout
    end

    def after_teardown
      super
      release_stdout
    end

    def initialize_environment
      music_path = File.expand_path('../music/', __FILE__)
      mock_config = mock('config')
      mock_config.stubs(:music_path).returns(music_path)
      Scanner.any_instance.stubs(:config).returns(mock_config)

      mock_file = mock('file')
      @mock_id3_tag = mock('id3_tag')
      mock_id3_tag.stubs(:title => 'MockTag')
      TagLib::MPEG::File.stubs(:new => mock_file)
      mock_file.stubs(:id3v2_tag => mock_id3_tag)

      #FakeFS.activate!
    end

    def deactivate_fake_fs
      #FakeFS.deactivate!
    end

    #Capture STDOUT from program for testing and not cluttering test output
    def capture_stdout
      @stdout = $stdout
      $stdout = StringIO.new
    end

    def release_stdout
      $stdout = @stdout
    end

    #Redirect intentional puts from within tests to the real STDOUT for troublshooting purposes.
    def puts(*args)
      @stdout.puts(*args)
    end

  end
end
require 'mocha/setup'

