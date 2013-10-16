class CreateTracks < ActiveRecord::Migration
  def change
    rename_table :root_folders, :music_folders
  end
end
