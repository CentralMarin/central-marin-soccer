class CreateCoachTranslation < ActiveRecord::Migration
  def up
    Coach.create_translation_table!({:bio => :string},
                                        {:migrate_data => true})
  end

  def down
    Coach.drop_translation_table!
  end
end
