class AcademyController < ApplicationController
  def index
    @academy_teams = Team.academy(Time.now.year)
  end
end
