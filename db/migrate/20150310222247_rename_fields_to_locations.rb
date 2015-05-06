class RenameFieldsToLocations < ActiveRecord::Migration
  def change
    add_column :fields, :type, :string, default: 'Field'
    rename_table :fields, :locations
  end
end
