class AddSubCategoryIdToNews < ActiveRecord::Migration
  def change
    add_column :article, :subcategory_id, :integer
  end
end
