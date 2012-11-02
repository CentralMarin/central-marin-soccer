class ApplicationController < ActionController::Base
  protect_from_forgery

  #before_filter :populate_teams

  protected

  def user_for_paper_trail
    user_signed_in? ? current_user : nil
  end

  #def populate_teams
  #  # TODO: Look into read_fragment as well as fragment caching
  #  @teams = Team.all
  #end

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end

  before_filter :set_locale

  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end

  def extract_locale_from_tld
    parsed_locale = request.host.split('.').first
    I18n.available_locales.include?(parsed_locale.to_sym) ? parsed_locale  : nil
  end
end
