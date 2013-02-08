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
    @part_name = 'information.tournaments'
    init_web_parts(@part_name)
  end
end
