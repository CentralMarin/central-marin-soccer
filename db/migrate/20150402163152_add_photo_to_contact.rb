class AddPhotoToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :image, :string
  end
end
