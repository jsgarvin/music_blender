require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'fakefs/safe'
require 'minitest/autorun'
require 'etc'
require 'pry'

SimpleCov.start

require 'mmp'

module MyMediaPlayer
  class MiniTest::Unit::TestCase
 
    add_setup_hook { |test_case| test_case.initialize_environment }
    add_setup_hook { |test_case| test_case.capture_stdout }

    add_teardown_hook { |test_case| test_case.deactivate_fake_fs }
    add_teardown_hook { |test_case| test_case.release_stdout }

    def initialize_environment
      initialize_fake_fs
      #stub_configuration
    end

    def initialize_fake_fs
      FakeFS.activate!
      FakeFS::FileSystem.clear
      #FileUtils.mkdir_p test_source_folder
      #FileUtils.mkdir_p test_source_folder + '/test_sub_folder'
      #File.open(test_source_folder + '/test_sub_folder/test_file_one.txt', 'w') do |test_file|
      #  test_file.write('Test File One')
      #end
    end

    def deactivate_fake_fs
      FakeFS.deactivate!
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

