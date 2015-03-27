class CreateEventGroups < ActiveRecord::Migration
  def change
    create_table :event_groups do |t|
      t.integer :event_id
      t.integer :groups, default: 0
      t.string :boys_age_range
      t.string :girls_age_range

      t.timestamps
    end
  end
end
