class RemoveManagerFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :manager_name
    remove_column :teams, :manager_email
    remove_column :teams, :manager_phone
  end
end
