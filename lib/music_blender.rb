require 'active_record'
require 'bundler/setup'
require 'find'
require 'io/wait'
require 'singleton'
require 'sqlite3'
require 'taglib'
require 'open3'

require_relative 'music_blender/artist'
require_relative 'music_blender/bootstrap'
require_relative 'music_blender/db_adapter'
require_relative 'music_blender/id3_adapter'
require_relative 'music_blender/music_folder'
require_relative 'music_blender/player'
require_relative 'music_blender/player_monitor'
require_relative 'music_blender/shell'
require_relative 'music_blender/track'

Thread.abort_on_exception = true

module MusicBlender
  BLENDER_ROOT = File.expand_path('../../', __FILE__)
end
