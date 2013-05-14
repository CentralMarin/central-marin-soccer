class InformationController < ApplicationController
  caches_page :index, :gzip => true
  caches_page :gold, :gzip => true
  caches_page :silver, :gzip => true
  caches_page :academy, :gzip => true
  caches_page :scholarship, :gzip => true
  caches_page :referees, :gzip => true
  caches_page :tournaments, :gzip => true
  caches_page :tournaments_previous_winners, :gzip => true

  def init_web_parts(web_parts)
    # Determine if the current user can edit the page
    @editable = can?(:manage, WebPart)
    @web_parts = WebPart.load(web_parts)
  end

  def index
    @part_name = 'information.overview'
    init_web_parts(@part_name)
  end

  def gold
    @part_name = 'information.gold'
    init_web_parts(@part_name)

    render :action => 'level'
  end

  def silver
    @part_name = 'information.silver'
    init_web_parts(@part_name)

    render :action => 'level'
  end

  def academy
    @part_name = 'information.academy'
    init_web_parts(@part_name)

    @academy_teams = Team.academy(Time.now.year)
  end

  def scholarship
    @part_name = 'information.scholarship'
    init_web_parts(@part_name)
  end

  def referees
    @part_name = 'information.referee'
    init_web_parts(@part_name)
  end

  def tournaments
    @top_level_section_name = 'menu.tournaments'

    @part_name_overview = 'information.tournaments'
    @part_name_mission_bell = 'information.tournaments.mission_bell'
    @part_name_premier_challenge = 'information.tournaments.premier_challenge'
    @part_name_footer = 'information.tournaments.footer'
    init_web_parts(
        [
            @part_name_overview,
            @part_name_mission_bell,
            @part_name_premier_challenge,
            @part_name_footer
        ]
    )
    @tournaments = [
        {name: 'Premier Challenge', id: 'premier_challenge', overview: @part_name_premier_challenge },
        {name: 'Mission Bell', id: 'mission_bell', overview: @part_name_mission_bell}
    ]
    @years = [I18n.t('information.current'), I18n.t('information.previous')]
  end

  def tournaments_previous_winners
    # tournament name and (current or past) to build name
    tournament_name = params[:name]
    year = params[:year]
    part_name = "information.tournaments.#{tournament_name}.#{year}"

    # Load the web part
    web_part = WebPart.load(part_name)

    # build our object
    winners = {
        web_part_name: web_part[part_name]['name'],
        html: web_part[part_name]['html'],
        tournament_name: tournament_name.gsub('_', ' ').titleize,
        year: year.capitalize
    }

    respond_to do |format|
      format.json {render :json => winners}
    end
  end
end
