class MoveCarouselToArticleCarousel < ActiveRecord::Migration
  def change
    create_table :article_carousels do |t|
      t.integer :article_id, :null => false
      t.integer :carousel_order, :null => false
    end

    remove_column :articles, :carousel
  end
end
