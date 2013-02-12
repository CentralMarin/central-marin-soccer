class AddManagerAndTeamSnapToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :manager_name, :string
    add_column :teams, :manager_phone, :string
    add_column :teams, :manager_email, :string
    add_column :teams, :teamsnap_url, :string
  end
end
