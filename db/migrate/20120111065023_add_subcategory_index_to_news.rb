class AddSubcategoryIndexToNews < ActiveRecord::Migration
  def change
    add_index :news_items, :subcategory_id
  end
end
