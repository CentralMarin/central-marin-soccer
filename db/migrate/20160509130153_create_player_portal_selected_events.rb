class CreatePlayerPortalSelectedEvents < ActiveRecord::Migration
  def change
    create_table :player_portal_selected_events do |t|
      t.integer :player_portal_id
      t.integer :event_detail_id
    end
  end
end
