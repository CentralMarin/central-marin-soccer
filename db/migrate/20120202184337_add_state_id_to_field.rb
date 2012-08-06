class AddStateIdToField < ActiveRecord::Migration
  def change
    add_column :fields, :state_id, :integer
  end
end
