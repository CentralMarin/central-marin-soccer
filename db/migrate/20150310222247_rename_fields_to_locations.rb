class RenameFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :fields, :type, :string, default: 'Field'
    remove_column :fields, :club_name
    rename_table :fields, :locations
  end
end
