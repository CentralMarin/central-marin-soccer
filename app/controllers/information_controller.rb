class InformationController < ApplicationController
  def index
  end

  def gold
    @level = 'gold'
    # Get the bullets
    @bullets = I18n.t("gold.bullets")

    render :action => 'level'
  end

  def silver
    @level = 'silver'
    # Get the bullets
    @bullets = I18n.t("silver.bullets")
    render :action => 'level'
  end

  def academy
    @academy_teams = Team.academy(Time.now.year)
  end
end
