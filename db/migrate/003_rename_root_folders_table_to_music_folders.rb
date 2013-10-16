class RenameRootFoldersTableToMusicFolders < ActiveRecord::Migration
  def change
    rename_table :root_folders, :music_folders
    rename_column :tracks, :root_folder_id, :music_folder_id
  end
end
