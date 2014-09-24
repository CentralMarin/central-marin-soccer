class CreateCoachTranslation < ActiveRecord::Migration
  def up
    Coach.create_translation_table!({:bio => :text},
                                        {:migrate_data => true})
  end

  def down
    Coach.drop_translation_table!
  end
end
