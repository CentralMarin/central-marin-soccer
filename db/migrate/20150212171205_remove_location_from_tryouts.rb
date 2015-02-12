class RemoveLocationFromTryouts < ActiveRecord::Migration
  def change
    remove_column :tryout_types, :location
  end
end
