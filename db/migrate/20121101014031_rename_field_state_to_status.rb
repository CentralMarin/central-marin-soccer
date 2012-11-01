class RenameFieldStateToStatus < ActiveRecord::Migration
  def change
    rename_column :fields, :state_id, :status
  end
end
