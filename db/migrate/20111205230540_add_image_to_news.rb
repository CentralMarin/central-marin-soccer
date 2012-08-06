class AddImageToNews < ActiveRecord::Migration
  def change
    add_column :news_items, :image, :string
  end
end
