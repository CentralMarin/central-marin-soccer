class CreateTeamLevels < ActiveRecord::Migration
  def change
    create_table :team_levels do |t|
      t.string :name

      t.timestamps
    end
  end
end
