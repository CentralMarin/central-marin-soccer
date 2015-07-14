require "net/https"
require 'uri'
require 'json'
require 'csv'
require 'pathname'

DIVISION_ID = 3271
SEASON = 2015
ROSTER_ID = '1893703'

def log(message)
  puts "#{DateTime.now.strftime('%H:%M:%S')} - #{message}"
end

def http_get(url, headers)

  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.request_uri, headers)

  http.request(request)
end

def http_post(url, headers, data)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Post.new(uri.request_uri, headers)

  request.body = data.to_json
  http.request(request)
end

def http_put(url, headers, data)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Put.new(uri.request_uri, headers)

  request.body = data.to_json
  http.request(request)
end

def authenticate(user, pwd)

  response = http_get('https://api.teamsnap.com/v2/authentication', {'Content-Type' =>  'application/json',
                                                                     'X-Teamsnap-User' =>  user,
                                                                     'X-Teamsnap-Password' => pwd})

  if response.code == '204'
    # Grab the token
    return response['x-teamsnap-token']
  end

  nil
end

def get_teams(token)

  http_get('https://api.teamsnap.com/v2/teams',
                      {
                          'Content-Type' =>  'application/json',
                          'X-Teamsnap-Token' => token
                      })
end

def create_team(name, token)

  log "Checking to see if team already exists"
  # Check if the team already exists
  JSON.parse(get_teams(token).body).each do |team|
    if team['team']['team_name'].strip == name
      log "Team '#{name}' already exists"
      return team['team']['id']
    end
  end

  log "Creating Team '#{name}'"
  response = http_post('https://api.teamsnap.com/v2/teams',
                       {
                           'Content-Type' =>  'application/json',
                           'X-Teamsnap-Token' => token
                       },
                       {
                           'team' => {
                               'team_name' => name,
                               'sport_id' => 2,
                               'timezone' => 'Pacific Time (US & Canada)',
                               'country' => 'United States',
                               'zipcode' => 94901,
                               'team_season' => SEASON,
                               'is_youth' => true,
                               'division_id' => DIVISION_ID,
                               'logo_url' => 'https://drive.google.com/file/d/0B16fN6qYkbqaaUh3NTQzc3pXb2M/preview'
                           }
                       }
  )

  if response.code != '200'
    return nil
  end

  team_info = JSON.parse(response.body)
  team_info['team']['id']

end

def get_roster(team_id, token)
  response = http_get("https://api.teamsnap.com/v2/teams/#{team_id}/as_roster/#{ROSTER_ID}/rosters",
                      {
                          'Content-Type' =>  'application/json',
                          'X-Teamsnap-Token' => token
                      })

  if response.code == '200'
    JSON.parse(response.body)
  else
    log 'Unable to lookup roster for team'
    exit -1
  end
end

def create_roster(roster_data, team_id, token)

  response = http_post("https://api.teamsnap.com/v2/teams/#{team_id}/as_roster/#{ROSTER_ID}/rosters",
                       {
                           'Content-Type' =>  'application/json',
                           'X-Teamsnap-Token' => token
                       },
                       roster_data)

  if response.code != "200"
    log "Failed to create player #{roster_data['roster']['first']} #{roster_data['roster']['last']}"
  end

  log "Created #{roster_data['roster']['first']} #{roster_data['roster']['last']}"

  response.code

end

def roster_exists?(optimized_roster, roster)

  exists = false
  key = build_key(roster['roster']['first'], roster['roster']['last'], roster['roster']['contacts_attributes'].length > 0 ? roster['roster']['contacts_attributes'][0]['first'] : '')
  if optimized_roster[key]
    log "#{roster['roster']['first']} #{roster['roster']['last']} already exists"
    exists = true
  end

  exists
end

def build_key(first, last, parent_first)
  "#{first}|#{last}|#{parent_first}"
end

def optimize_current_roster(current_roster)
  optimized_roster = {}
  current_roster.each do |roster|
    key = build_key(roster['roster']['first'], roster['roster']['last'], roster['roster']['contacts'].length > 0 ? roster['roster']['contacts'][0]['first'] : '')
    optimized_roster[key] = true
  end
  optimized_roster
end