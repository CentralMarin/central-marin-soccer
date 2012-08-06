class HomeController < InheritedResources::Base

  before_filter :set_section_name

  def index
    @news_items = NewsItem.all(:limit => 4)
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.home'
  end
end
