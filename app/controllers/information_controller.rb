class InformationController < ApplicationController

  def init_web_parts(web_parts)
    # Determine if the current user can edit the page
    @part_name = web_parts
    @web_parts = WebPart.load(web_parts)
  end

  def index
    init_web_parts('information.overview')
  end

  def gold
    init_web_parts('information.gold')

    render :action => 'level'
  end

  def silver
    init_web_parts('information.silver')

    render :action => 'level'
  end

  def academy
    init_web_parts('information.academy')

    @academy_teams = Team.academy(Time.now.year)
  end

  def scholarship
    init_web_parts('information.scholarship')
  end

  def referees
    init_web_parts('information.referee')
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
        {:name => 'Mission Bell', :id => 'mission_bell', :overview => @part_name_mission_bell},
        {:name => 'Premier Challenge', :id => 'premier_challenge', :overview => @part_name_premier_challenge }
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
        :web_part_name => web_part[part_name]['name'],
        :html => web_part[part_name]['html'],
        :tournament_name => tournament_name.gsub('_', ' ').titleize,
        :year => year.capitalize
    }

    respond_to do |format|
      format.json {render :json => winners}
    end
  end
end
