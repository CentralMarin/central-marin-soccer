class RemoveLocationFromTryouts < ActiveRecord::Migration
  def change
    remove_column :tryouts, :location
  end
end
