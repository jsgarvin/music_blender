require 'rake/testtask'
require File.expand_path('../lib/my_music_player', __FILE__)

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
  File.open("#{MyMusicPlayer::PLAYER_ROOT}/db/schema.rb", 'w') do |file|
    ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
  end
end

task :environment do
  @config ||= MyMusicPlayer::Configuration.new({})
end

