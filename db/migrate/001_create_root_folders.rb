class CreateRootFolders < ActiveRecord::Migration
  def up
    create_table :root_folders do |t|
      t.column :path, :string, :null => false
    end
  end

  def down
    drop_table :root_folders
  end
end
