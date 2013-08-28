class CreateRootFolders < ActiveRecord::Migration
  def change
    create_table :root_folders do |t|
      t.column :path, :string, :null => false

      t.timestamps
    end
    add_index :root_folders, :path
  end
end
