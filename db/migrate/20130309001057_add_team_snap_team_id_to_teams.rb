class AddTeamSnapTeamIdToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :teamsnap_team_id, :string
  end
end
