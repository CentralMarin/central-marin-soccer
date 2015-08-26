class InformationController < ApplicationController

  def init_web_parts(page_name)

    page = Page.find_by(name: page_name)

    @part_name = page.web_parts.map {|part| part.name } unless page.nil?

    # if we only have one element in the array, return the element
    @part_name = @part_name[0] if not @part_name.nil? and @part_name.length == 1
    @web_parts = WebPart.load(@part_name)
  end

  def index
    init_web_parts('Information')
  end

  def gold
    init_web_parts('Gold')

    render :action => 'level'
  end

  def silver
    init_web_parts('Silver')

    render :action => 'level'
  end

  def academy
    init_web_parts('Academy')

    @academy_teams = Team.academy(Time.now.year)
  end

  def scholarship
    init_web_parts('On Equal Footing')
  end

  def referees
    init_web_parts('Referees')
  end

  def tournaments
    @top_level_section_name = 'menu.tournaments'

    @part_name_overview = 'information.tournaments'
    @part_name_mission_bell = 'information.tournaments.mission_bell'
    @part_name_premier_challenge = 'information.tournaments.premier_challenge'
    @part_name_footer = 'information.tournaments.footer'
    init_web_parts('Tournaments')
    @tournaments = [
        {:name => 'Mission Bell', :id => 'mission_bell', :overview => @part_name_mission_bell},
        {:name => 'Premier Challenge', :id => 'premier_challenge', :overview => @part_name_premier_challenge }
    ]
    @years = [I18n.t('information.current'), I18n.t('information.previous')]
  end
end
