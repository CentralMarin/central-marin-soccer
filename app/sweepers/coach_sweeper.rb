class CoachSweeper < ActionController::Caching::Sweeper
  observe Coach

  def after_create(coach)
    expire_cache_for(coach)
  end

  def after_update(coach)
    expire_cache_for(coach)
  end

  def after_destroy(coach)
    expire_cache_for(coach)
  end

  private
  def expire_cache_for(coach)
    # Expire the index page now that we added a new team
    expire_page(:controller => '/coaches', :action => 'index')
    expire_page("/coaches/#{coach.id}.json")
  end
end