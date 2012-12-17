class MoveCarouselToArticleCarousel < ActiveRecord::Migration
  def change
    create_table :article_carousels, :id => false do |t|
      t.integer :article_id, :null => false
      t.integer :order, :null => false
    end

    remove_column :articles, :carousel
  end
end
