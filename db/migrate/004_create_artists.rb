class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.column :name, :string, :null => false

      t.timestamps
    end
    add_index :artists, :name
    add_column :tracks, :artist_id, :integer
  end
end
