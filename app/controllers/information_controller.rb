class InformationController < CmsController

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
