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
    unless response.success?
      return nil
    end

    players = []
    coaches = []
    volunteers = []
    response['members'].each do |member|
      if member['is_player']
        players << member['name']
      elsif not member['position'].blank? and member['position'].downcase.include?('coach')
        coaches << "#{member['name']} - #{member['position']}"
      else
        volunteers << "#{member['name']} - #{member['position']}"
      end
    end
    players.sort!
    response['players'] = players

    if coaches.length == 0
      coaches << 'TBD - Coach'
    end
    response['coaches'] = coaches

    if volunteers.length == 0
      volunteers << 'TBD - Manager'
    end
    response['volunteers'] = volunteers

    # TODO: Sort the players
    # TODO: Pull out the coach(es)
    # TODO: Pull out the manager(s)

    response
  end

  private

  def self.by_year_and_gender(response)
    response['teams'].group_by{|team| [team['year'], team['gender']]}
  end
end

