require 'rake/testtask'
require File.expand_path('../lib/my_music_player', __FILE__)

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
  task :migrate => :environment do
    dba.migrate_db
  end
end

task :environment do
  dba.establish_connection
end

def dba
  @dba ||= MyMusicPlayer::DbAdapter.new
end

