class AddTryoutTypeToTryouts < ActiveRecord::Migration
  def change
    add_column :tryouts, :tryout_type_id, :integer
  end
end
