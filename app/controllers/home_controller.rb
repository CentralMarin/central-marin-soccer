class HomeController < InheritedResources::Base

  before_filter :set_section_name

  def index
    @articles = Article.all(:limit => 4)
    field_status_count = Field.count(:all, group: 'status')  # Check to see how many fields are open, closed, and call
    @fields_status = {}
    Field.statuses.each_with_index do |status, index|
      @fields_status[status] = field_status_count[index] || 0
    end
  end

  protected

  def set_section_name
    @top_level_section_name = 'menu.home'
  end
end
