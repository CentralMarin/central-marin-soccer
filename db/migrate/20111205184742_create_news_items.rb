class CreateNewsItems < ActiveRecord::Migration
  def change
    create_table :news_items do |t|
      t.string :title
      t.text :body
      t.string :author
      t.boolean :carousel
      t.integer :news_category_id

      t.timestamps
    end
  end
end
