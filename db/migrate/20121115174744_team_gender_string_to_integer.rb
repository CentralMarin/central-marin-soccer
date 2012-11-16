class TeamGenderStringToInteger < ActiveRecord::Migration
  def change
    change_column :teams, :gender, :integer
  end
end
