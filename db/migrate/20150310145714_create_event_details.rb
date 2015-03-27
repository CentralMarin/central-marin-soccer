class CreateEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details do |t|
      t.datetime :start
      t.integer :duration
      t.integer :location_id
      t.integer :event_group_id

      t.timestamps
    end
  end
end
