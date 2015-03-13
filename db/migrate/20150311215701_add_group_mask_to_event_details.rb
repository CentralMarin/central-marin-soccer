class AddGroupMaskToEventDetails < ActiveRecord::Migration
  def change
    add_column :event_details, :groups, :integer, default: 0
  end
end
