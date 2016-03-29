class CreateNewEventDetails < ActiveRecord::Migration
  def change
    create_table :event_details do |t|

      t.integer :event_id
      t.integer :location_id
      t.datetime :start
      t.integer :length
      t.integer :boys_age_groups
      t.integer :girls_age_groups

      t.timestamps null: false
    end
  end
end
