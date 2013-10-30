require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'minitest/autorun'
require 'factory_girl'
require 'etc'
require 'pry'
require 'assert_difference'

SimpleCov.start

require 'music_blender'

FactoryGirl.find_definitions
module MusicBlender
  MUSIC_PATH = "#{BLENDER_ROOT}/test/music"

  class MiniTest::Unit::TestCase
    include AssertDifference
    include FactoryGirl::Syntax::Methods

    ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
    silence_stream(STDOUT)  { load("#{BLENDER_ROOT}/db/schema.rb") }

    def before_setup
      super
      capture_stdout
      Track.any_instance.stubs(:persist_rating_to_id3_tag)
      Track.any_instance.stubs(:id3_adapter => OpenStruct.new(:title => 'foo', :artist => 'bar', :rating => 42))
    end

    def after_teardown
      super
      release_stdout
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
