require 'bundler/setup'
require 'find'
require 'io/wait'
require 'singleton'
require 'open3'

require File.expand_path('../my_music_player/configuration', __FILE__)
require File.expand_path('../my_music_player/player', __FILE__)
require File.expand_path('../my_music_player/scanner', __FILE__)
require File.expand_path('../my_music_player/shell', __FILE__)

Thread.abort_on_exception = true
