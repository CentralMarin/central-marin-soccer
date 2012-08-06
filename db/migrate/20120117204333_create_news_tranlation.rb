class CreateNewsTranlation < ActiveRecord::Migration
  def up
    NewsItem.create_translation_table!({:title => :string, :body => :text},
          {:migrate_data => true})
  end

  def down
    NewsItem.drop_translation_table!
  end
end
