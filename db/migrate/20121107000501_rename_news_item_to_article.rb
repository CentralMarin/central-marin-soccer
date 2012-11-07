class RenameNewsItemToArticle < ActiveRecord::Migration
  def up
    rename_table :news_items, :articles
    rename_table :news_item_translations, :article_translations
  end

  def down
    rename_table :articles, :news_items
    rename_table  :article_translations, :news_item_translations
  end
end
