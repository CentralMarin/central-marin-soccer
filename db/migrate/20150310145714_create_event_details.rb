class CreateEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details do |t|
      t.datetime :start
      t.integer :duration
      t.integer :field_id
      t.integer :event_id

      t.timestamps
    end
  end
end
