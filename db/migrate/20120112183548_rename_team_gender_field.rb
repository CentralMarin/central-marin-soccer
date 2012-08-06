class RenameTeamGenderField < ActiveRecord::Migration
  def change
    rename_column :teams, :gender_id, :gender
    change_column :teams, :gender, :string
  end
end
