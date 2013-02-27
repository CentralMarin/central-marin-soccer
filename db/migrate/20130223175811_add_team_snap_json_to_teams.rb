class AddTeamSnapJsonToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :teamsnap_json, :text
  end
end
