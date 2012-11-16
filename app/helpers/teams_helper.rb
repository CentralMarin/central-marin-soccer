module TeamsHelper
  def find_teams(gender, year)

    @teams.find_all {|team| team.year == year && team.gender == gender }

  end
end
