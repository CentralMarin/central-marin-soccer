# encoding: utf-8

class Team
  include HTTParty

  def self.teams
    response = get('https://api.centralmarinsoccer.com/teams/')
    if response.success?
      by_year_and_gender(response)
    else
      raise response.response
    end
  end

  def self.find(id)
    response = get("https://api.centralmarinsoccer.com/teams/#{id}")
    if response.success?
      response
    else
      raise response.response
    end
  end

  private

  def self.by_year_and_gender(response)
    response['teams'].group_by{|team| [team['year'], team['gender']]}
  end
end

