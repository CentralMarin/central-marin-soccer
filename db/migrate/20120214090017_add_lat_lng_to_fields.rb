class AddLatLngToFields < ActiveRecord::Migration
  def change
    add_column :fields, :lat, :decimal, :precision => 15, :scale => 10
    add_column :fields, :lng, :decimal, :precision => 15, :scale => 10
    remove_column :fields, :map_url
  end
end
