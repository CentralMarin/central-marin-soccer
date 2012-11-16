class RenameTeamAgeToYear < ActiveRecord::Migration
  def change
    rename_column :teams, :age, :year
  end
end
