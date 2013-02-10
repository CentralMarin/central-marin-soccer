class InformationController < ApplicationController
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
    init_web_parts([@part_name_overview, @part_name_mission_bell, @part_name_premier_challenge, @part_name_footer])
  end
end
