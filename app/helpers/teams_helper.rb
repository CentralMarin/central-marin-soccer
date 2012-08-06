module TeamsHelper
  def find_teams(gender, age)

    @teams.find_all {|team| team.age == age && team.gender == gender }

  end
end
