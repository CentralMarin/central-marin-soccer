class CreateDropEvents < ActiveRecord::Migration
  def change
    drop_table :events
    drop_table :event_translations
    drop_table :event_groups
    drop_table :event_details
  end
end
