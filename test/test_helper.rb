require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'minitest/autorun'
require 'factory_girl'
require 'etc'
require 'pry'
require 'assert_difference'

SimpleCov.start

require 'my_music_player'

FactoryGirl.find_definitions
module MyMusicPlayer
  MUSIC_FOLDER = 'mock_music_folder'

  class MiniTest::Unit::TestCase
    include AssertDifference
    include FactoryGirl::Syntax::Methods

    attr_reader :mock_config, :mock_id3_tag

    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
    silence_stream(STDOUT)  { load("#{PLAYER_ROOT}/db/schema.rb") }

    def before_setup
      super
      capture_stdout
      MusicFolder.stubs(:current).returns(mock_music_folder)
      Track.any_instance.stubs(:persist_rating_to_id3_tag)
      Track.any_instance.stubs(:id3_adapter => OpenStruct.new(:title => 'foo', :artist => 'bar', :rating => 42))
    end

    def after_teardown
      super
      release_stdout
    end

    def mock_music_folder
      @mock_music_folder ||= mock('music_folder').tap do |mock_music_folder|
        mock_music_folder.responds_like(MusicFolder.new)
        music_path = File.expand_path('../music/', __FILE__)
        mock_music_folder.stubs(:path).returns(music_path)
      end
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

