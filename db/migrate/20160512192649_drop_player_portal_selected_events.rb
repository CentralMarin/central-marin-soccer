class DropPlayerPortalSelectedEvents < ActiveRecord::Migration
  def change
    drop_table :player_portal_selected_events
  end
end
