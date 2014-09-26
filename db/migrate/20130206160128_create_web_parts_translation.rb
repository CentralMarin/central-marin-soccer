class CreateWebPartsTranslation < ActiveRecord::Migration
  def up
    WebPart.create_translation_table!({:html => :text},
                                        {:migrate_data => true})
  end

  def down
    WebPart.drop_translation_table!
  end
end
