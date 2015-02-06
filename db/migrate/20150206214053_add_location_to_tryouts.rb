class AddLocationToTryouts < ActiveRecord::Migration
  def change
    add_column :tryouts, :location, :string
  end
end
