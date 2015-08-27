require "net/https"
require "json"

class TeamsController < CmsController

  # GET /teams
  def index

    init_web_parts('Teams')

    @top_level_section_name = 'menu.teams'

    teams = Team.order('year desc', :gender_id, :team_level_id)
    @teams_by_year_and_gender = process_teams(teams)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /teams/1
  def show
    @team = Team.find(params[:id])
    @articles = Article.where(:category_id => Article.category_id(:team), :team_id => [0,@team.id]).order("updated_at asc").limit(10).all
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def teamsnap()
    team = Team.find(params[:id])
    json = team.teamsnap_json

    render :json => json
  end

  protected

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
