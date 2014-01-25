class HomeSweeper < ActionController::Caching::Sweeper

  observe ArticleCarousel, Field

  def after_create(model)
    expire_cache_for()
  end

  def after_update(model)
    expire_cache_for()
  end

  def after_destroy(model)
    expire_cache_for()
  end

  private
  def expire_cache_for()
    # Expire the index page now that we added a new team
    #expire_page(:controller => '/home', :action => 'index')
  end
end
