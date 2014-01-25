class HomeController < InheritedResources::Base

  caches_page :index, :gzip => true

  before_filter :set_section_name

  def index
    # Get all articles to display in the carousel in the proper order
    @articles = ArticleCarousel.find(:all, :order => "carousel_order").map {|ac| ac.article}
    field_status_count = Field.count(:all, group: 'status')  # Check to see how many fields are open, closed, and call
    @fields_status = {}
    Field.statuses.each_with_index do |status, index|
      @fields_status[status] = field_status_count[index] || 0
    end
  end

  def registration
    #Get all teams
    @teams = Team.all
  end



  protected

  def set_section_name
    @top_level_section_name = 'menu.home'
  end
end
