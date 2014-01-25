class WebPartSweeper < ActionController::Caching::Sweeper
  observe WebPart

  def after_create(web_part)
    expire_cache_for(web_part)
  end

  def after_update(web_part)
    expire_cache_for(web_part)
  end

  def after_destroy(web_part)
    expire_cache_for(web_part)
  end

  private
  def expire_cache_for(web_part)
    # Expire the index page now that we added a new team
    #expire_page(:controller => '/information', :action => 'index')
    #expire_page(:controller => '/information', :action => 'gold')
    #expire_page(:controller => '/information', :action => 'silver')
    #expire_page(:controller => '/information', :action => 'academy')
    #expire_page(:controller => '/information', :action => 'scholarship')
    #expire_page(:controller => '/information', :action => 'referees')
    #expire_page(:controller => '/information', :action => 'tournaments')
    ['premier_challenge', 'mission_bell'].each do |name|
      ['current', 'previous'].each do |year|
        #expire_page("/tournaments/#{name}/#{year}.json")
      end
    end
  end
end