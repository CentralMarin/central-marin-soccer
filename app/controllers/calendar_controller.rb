class CalendarController < ApplicationController

  before_filter :set_section_name

  protected

  def set_section_name
          @top_level_section_name = 'menu.calendar'
  end

end
