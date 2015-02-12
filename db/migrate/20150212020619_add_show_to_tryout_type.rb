class AddShowToTryoutType < ActiveRecord::Migration
  def change
    add_column :tryout_types, :show, :boolean
  end
end
