class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.column :relative_path, :string, :null => false
      t.column :last_played_at, :datetime
      t.column :rating, :integer
      t.column :title, :string
      t.column :root_folder_id, :integer

      t.timestamps
    end
    add_index :tracks, [:root_folder_id, :relative_path]
    add_index :tracks, [:root_folder_id, :last_played_at]
  end
end
