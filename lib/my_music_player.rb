require 'active_record'
require 'bundler/setup'
require 'find'
require 'io/wait'
require 'singleton'
require 'sqlite3'
require 'taglib'
require 'open3'

require_relative 'my_music_player/artist'
require_relative 'my_music_player/bootstrap'
require_relative 'my_music_player/db_adapter'
require_relative 'my_music_player/id3_adapter'
require_relative 'my_music_player/music_folder'
require_relative 'my_music_player/player'
require_relative 'my_music_player/player_monitor'
require_relative 'my_music_player/shell'
require_relative 'my_music_player/track'

Thread.abort_on_exception = true

module MyMusicPlayer
  PLAYER_ROOT = File.expand_path('../../', __FILE__)
end
