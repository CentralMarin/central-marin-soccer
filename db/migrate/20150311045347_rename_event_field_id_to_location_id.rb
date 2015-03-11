class RenameEventFieldIdToLocationId < ActiveRecord::Migration
  def change
    rename_column :event_details, :field_id, :location_id
  end
end
