class CreateTeamLevelsTranslation < ActiveRecord::Migration
  def up
    TeamLevel.create_translation_table!({:name => :string},
                                       {:migrate_data => true})
  end

  def down
    TeamLevel.drop_translation_table!
  end
end
