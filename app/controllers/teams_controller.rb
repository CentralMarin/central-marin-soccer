require "net/https"
require "json"

class TeamsController < ApplicationController

  caches_page :record, :roster, :schedule

  # GET /teams
  def index

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

    json = teamsnap('https://api.teamsnap.com/v2/teams/49832/as_roster/680909/events/upcoming')
    schedule = []
    json.each do |game|
      event = game['event']
      name = "#{event['shortlabel'].nil? || event['shortlabel'].blank? ? event['type'] : event['shortlabel']}"
      if (event['type'] == 'Game')
        name += " #{event['home_or_away'].nil? || event['home_or_away'] == 1 ? 'vs.' : 'at'} #{event['opponent']['opponent_name']}"
      end
      date_start = DateTime.parse(event['event_date_start'])
      date_end = DateTime.parse(event['event_date_end'])

      schedule << {
          name: name,
          date: date_start.strftime("%a, %b %d"),
          start: date_start.strftime("%I:%M %p"),
          end: (date_start == date_end ? nil : date_end.strftime("%I:%M %p")),
          location: event['location']['location_name']
      }
    end

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
