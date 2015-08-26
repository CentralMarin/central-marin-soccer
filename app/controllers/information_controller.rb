class InformationController < ApplicationController

  def init_web_parts(page_name)

    page = Page.find_by(name: page_name)

    part_name = []
    part_name = page.web_parts.map {|part| part.name } unless page.nil?
    @web_parts = WebPart.load(part_name)

    part_name = part_name[0] if part_name.length == 1
    part_name
  end

  def index
    init_web_parts('Information')
  end

  def gold
    @part_name = init_web_parts('Gold')

    render :action => 'level'
  end

  def silver
    @part_name = init_web_parts('Silver')

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

    init_web_parts('Tournaments')
  end
end
