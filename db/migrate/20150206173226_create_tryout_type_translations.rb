class CreateTryoutTypeTranslations < ActiveRecord::Migration
  def up
	TryoutType.create_translation_table!({
	  header: :string,
	  body: :text
        }, {
	  migrate_date: true
   	})
    end

  def down
    TryoutType.drop_translation_table! migrate_data: true
  end

end
