class FieldSweeper < ActionController::Caching::Sweeper
  observe Field

  def after_create(field)
    expire_cache_for(field)
  end

  def after_update(field)
    expire_cache_for(field)
  end

  def after_destroy(field)
    expire_cache_for(field)
  end

  private
  def expire_cache_for(field)
    # Expire the index page now that we added a new team
    #expire_page(:controller => '/fields', :action => 'index')
  end
end