class ArticlesController < ApplicationController

  before_filter :set_section_name

  def index
    @articles = Article.find_all_by_category_id(Article.category_id(:club)) || []
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.news'
  end

end
