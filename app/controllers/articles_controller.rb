class ArticlesController < ApplicationController

  before_filter :set_section_name

  def index
    @articles = Article.where(:category_id => Article.category_id(:club)).all.order('updated_at desc') || []
  end

  protected

  def set_section_name
          @top_level_section_name = 'menu.news'
  end

end
