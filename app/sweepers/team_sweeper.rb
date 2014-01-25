class TeamSweeper < ActionController::Caching::Sweeper
  observe Team

  def after_create(team)
    expire_cache_for(team)
  end

  def after_update(team)
    expire_cache_for(team)
  end

  def after_destroy(team)
    expire_cache_for(team)
  end

  private
  def expire_cache_for(team)
    # Expire the index page now that we added a new team
    #expire_page(:controller => '/teams', :action => 'index')
    #expire_page(:controller => '/teams', :action => 'show', :id => team.to_param)
  end
end