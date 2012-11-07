class RenameNewsItemIdToArticleId < ActiveRecord::Migration
  def change
    rename_column :article_translations, :news_item_id, :article_id
  end
end
