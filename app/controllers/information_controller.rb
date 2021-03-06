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

  def field_setup
    init_web_parts('Field Setup')
  end
end
