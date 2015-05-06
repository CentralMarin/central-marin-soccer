require 'spec_helper'

feature "TeamsActiveAdmins" do

  context "As an administrator" do

    before do
      login_as_admin
    end

    it "the admin teams view renders" do

      visit admin_teams_path
      assert current_path == admin_teams_path
    end

    it "he should create a new team", :js => true do

      team = FactoryGirl.build(:team)

      visit admin_teams_path
      click_link "New Team"

      select team.coach.name, :from => "team[coach_id]"
      select team.team_level.name, :from => "team[team_level_id]"
      fill_in "Year", :with => team.year
      select team.gender, :from => "team[gender]"
      fill_in "Name", :with => team.name
      fill_in "Teamsnap team", :with => team.teamsnap_team_id

      click_button "Create Team"

      assert_path admin_team_path(Team.last)

      page.should have_content(team.name)

    end
  end
end