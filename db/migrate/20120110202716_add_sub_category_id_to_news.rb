class AddSubCategoryIdToNews < ActiveRecord::Migration
  def change
    add_column :news_items, :subcategory_id, :integer
  end
end
