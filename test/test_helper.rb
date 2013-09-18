require 'rubygems'
require 'bundler/setup'
require 'simplecov'
#require 'fakefs/safe'
require 'minitest/autorun'
require 'factory_girl'
require 'etc'
require 'pry'
require 'assert_difference'

SimpleCov.start

require 'my_music_player'

FactoryGirl.find_definitions
module MyMusicPlayer
  CONFIG = 'mock_config'

  class MiniTest::Unit::TestCase
    include AssertDifference
    include FactoryGirl::Syntax::Methods

    attr_reader :mock_config, :mock_id3_tag

    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
    silence_stream(STDOUT)  { load("#{PLAYER_ROOT}/db/schema.rb") }

    def before_setup
      super
      capture_stdout
    end

    def after_teardown
      super
      release_stdout
    end

    def initialize_environment
      #FakeFS.activate!
    end

    def mock_config
      @mock_config ||= mock('config').tap do |mock_config|
        mock_config.responds_like_instance_of(Configuration)
        music_path = File.expand_path('../music/', __FILE__)
        mock_config.stubs(:music_path).returns(music_path)
      end
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

