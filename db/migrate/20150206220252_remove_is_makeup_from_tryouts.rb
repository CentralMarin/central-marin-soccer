class RemoveIsMakeupFromTryouts < ActiveRecord::Migration
  def change
    remove_column :tryouts, :is_makeup
  end
end
