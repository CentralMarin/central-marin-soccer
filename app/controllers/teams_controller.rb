require "net/https"
require "json"

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
    @article = Article.find_all_by_category_id_and_team_id(Article.category_id(:team), @team.id, order: "created_at asc", limit: 20)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def record()
    json = teamsnap('https://api.teamsnap.com/v2/teams/49832')
    record = {record: json['team']['formatted_record']}

    respond_to do |format|
      format.json {render :json => record}
    end
  end

  def roster()

    json = teamsnap('https://api.teamsnap.com/v2/teams/49832/as_roster/680909/rosters')
    roster = []
    json.each do |player|
      roster << {first: player['roster']['first'], last: player['roster']['last']}
    end

    respond_to do |format|
      format.json {render :json => roster}
    end
  end

  def schedule()

    json = teamsnap('https://api.teamsnap.com/v2/teams/49832/as_roster/680909/events')
    schedule = []
    json.each do |game|
      schedule << {
          type: game['event']['type'],
          date_start: game['event']['event_date_start'],
          date_end: game['event']['event_date_end'],
          location: game['event']['location']['location_name']
      }
    end

    # TODO: show the 10 upcoming. Fill with old if not 10 upcoming

    respond_to do |format|
      format.json {render :json => schedule}
    end
  end

  protected

  def teamsnap(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['X-Teamsnap-Token'] = '170b851e-f386-47a0-b6a5-9d5ed6597dbd'

    response = http.request(request)
    JSON.parse(response.body)
  end

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
