class RenameTeamGenderToGenderId < ActiveRecord::Migration
  def change
    rename_column :teams, :gender, :gender_id
  end
end
