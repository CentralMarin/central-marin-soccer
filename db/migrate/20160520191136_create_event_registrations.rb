class CreateEventRegistrations < ActiveRecord::Migration
  def self.up
    create_table :event_registrations do |t|

      t.integer  :event_detail_id, index: true
      t.integer  :player_portal_id, index: true
      t.string      :charge
      t.integer     :amount

      t.timestamps null: false, default: Time.now
    end

    execute "insert into event_registrations (player_portal_id, event_detail_id) select player_portal_id, event_detail_id from event_details_player_portals"
  end

  def self.down

    drop_table :event_registrations
  end
end
