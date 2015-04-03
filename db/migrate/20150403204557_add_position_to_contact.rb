class AddPositionToContact < ActiveRecord::Migration
  def change
    rename_column :contacts, :position, :club_position
    rename_column :contact_translations, :position, :club_position
    add_column :contacts, :row_order, :integer
  end
end
