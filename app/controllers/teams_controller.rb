class TeamsController < ApplicationController

  before_filter :set_section_name

  # GET /teams
  def index

    teams = Team.order('year desc', :gender_id, :team_level_id)
    @teams_by_year_and_gender = process_teams(teams)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])
    @article = Article.find_all_by_category_id_and_subcategory_id(Article.category_id(:team), @team.id, order: "created_at asc", limit: 20)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  protected

  def set_section_name
    @top_level_section_name = 'menu.teams'
  end

  def process_teams(teams)
    return {} if teams.nil?

    teams_by_year_and_gender = {}
    teams.each do |team|
      if teams_by_year_and_gender[team.year].nil?
        teams_by_year_and_gender[team.year] = []
        teams_by_year_and_gender[team.year][0] = []
        teams_by_year_and_gender[team.year][1] = []
      end
      teams_by_year_and_gender[team.year][team.gender_id] << team
    end

    return teams_by_year_and_gender
  end
end
