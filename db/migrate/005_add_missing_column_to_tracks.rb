class AddMissingColumnToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :missing, :boolean, :default => false
  end
end
