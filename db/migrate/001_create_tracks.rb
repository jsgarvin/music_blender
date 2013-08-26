class CreateTracks < ActiveRecord::Migration
  def up
    create_table :tracks do |t|
      t.column :name, :string, :null => false
    end
  end

  def down
    drop_table :tracks
  end
end
