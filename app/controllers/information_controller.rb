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

  def scholarship
    # load translations
    @goals = I18n.t("scholarship.goal_text")
    @history = I18n.t("scholarship.history_bullets")
    @qualifications = I18n.t('scholarship.qualifications_bullets')
    @steps = I18n.t('scholarship.process.steps')
  end
end
