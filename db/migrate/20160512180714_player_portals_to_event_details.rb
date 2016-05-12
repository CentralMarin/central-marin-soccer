class PlayerPortalsToEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details_player_portals, id: false do |t|
      t.belongs_to :player_portal
      t.belongs_to :event_detail
    end

    add_index :event_details_player_portals, [:player_portal_id, :event_detail_id], unique: true, name: 'player_portals_event_details_index'
  end
end
