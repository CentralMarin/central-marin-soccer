class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :age
      t.integer :gender_id
      t.string :name
      t.integer :coach_id
      t.integer :team_level_id

      t.timestamps
    end
  end
end
