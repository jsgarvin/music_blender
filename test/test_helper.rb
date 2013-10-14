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
  ROOT_FOLDER = 'mock_root_folder'

  class MiniTest::Unit::TestCase
    include AssertDifference
    include FactoryGirl::Syntax::Methods

    attr_reader :mock_config, :mock_id3_tag

    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
    silence_stream(STDOUT)  { load("#{PLAYER_ROOT}/db/schema.rb") }

    def before_setup
      super
      capture_stdout
      RootFolder.stubs(:current).returns(mock_root_folder)
      Track.any_instance.stubs(:persist_rating_to_id3_tag)
    end

    def after_teardown
      super
      release_stdout
    end

    def mock_root_folder
      @mock_root_folder ||= mock('root_folder').tap do |mock_root_folder|
        mock_root_folder.responds_like(RootFolder.new)
        music_path = File.expand_path('../music/', __FILE__)
        mock_root_folder.stubs(:path).returns(music_path)
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

