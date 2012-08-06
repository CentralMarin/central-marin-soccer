class RenameNewsCategory < ActiveRecord::Migration
  def change
    rename_column :news_items, :news_category_id, :category_id
  end
end
