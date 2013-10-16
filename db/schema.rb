# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 3) do

  create_table "music_folders", force: true do |t|
    t.string   "path",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "music_folders", ["path"], name: "index_music_folders_on_path"

  create_table "tracks", force: true do |t|
    t.string   "relative_path",   null: false
    t.datetime "last_played_at"
    t.integer  "rating"
    t.string   "title"
    t.integer  "music_folder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracks", ["music_folder_id", "last_played_at"], name: "index_tracks_on_music_folder_id_and_last_played_at"
  add_index "tracks", ["music_folder_id", "relative_path"], name: "index_tracks_on_music_folder_id_and_relative_path"

end
