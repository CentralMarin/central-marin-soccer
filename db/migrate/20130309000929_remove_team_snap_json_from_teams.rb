class RemoveTeamSnapJsonFromTeams < ActiveRecord::Migration
  def change
    remove_column :teams, :teamsnap_json
    remove_column :teams, :teamsnap_url
  end
end
