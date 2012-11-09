class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :author
      t.string :image
      t.integer :category_id
      t.integer :subcategory_id

      t.boolean :carousel
      t.timestamps
    end

    add_index :articles, :subcategory_id

    Article.create_translation_table!({:title => :string, :body => :text},
                                       {:migrate_data => true})

  end

  def down
    drop_table :articles
    Article.drop_translation_table!
  end
end
