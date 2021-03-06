require File.expand_path('../lib/music_blender/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "music_blender"
  s.version = MusicBlender::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Jonathan S. Garvin"]
  s.email = ["jon@5valleys.com"]
  s.homepage = "https://github.com/jsgarvin/music_blender"
  s.summary = %q{Simple MP3 player written in Ruby.}
  s.description = %q{A simple MP3 player written in Ruby. Depends on mpg123.}

  s.add_dependency('activerecord')
  s.add_dependency('sqlite3')
  s.add_dependency('taglib-ruby')

  s.add_development_dependency('assert_difference')
  s.add_development_dependency('factory_girl')
  s.add_development_dependency('fakefs')
  s.add_development_dependency('mocha')
  s.add_development_dependency('pry')
  s.add_development_dependency('simplecov')

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
