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

def create_team(name, token)

  log "Checking to see if team already exists"
  # Check if the team already exists
  response = http_get('https://api.teamsnap.com/v2/teams',
                      {
                          'Content-Type' =>  'application/json',
                          'X-Teamsnap-Token' => token
                      })
  JSON.parse(response.body).each do |team|
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

######################################################################################

# Grab User Name and Password from the command line
if ARGV.length != 3
  puts 'Usage: Setup.rb <user> <pwd> <csv file>'
  exit(-1)
end

user = ARGV[0]
pwd = ARGV[1]
csv_file = ARGV[2]

# Verify the csv file exists
if not File.exists? csv_file
  log "Unable to locate file #{csv_file}"
  exit -1
end

# Parse the filename for the name of the team replacing underscore characters with spaces
team_name = File.basename(ARGV[2], '.csv')
team_name = team_name.gsub!('_', ' ') unless not team_name.include? '_'
team_name = team_name.gsub!('|','/') unless not team_name.include? '|'

# Login to TeamSnap
log "Logging into TeamSnap as user: #{user}"
token = authenticate(user, pwd)
if token.nil?
  log "Invalid user name or password"
  exit -1
end

# Create the Team
log "Creating team: #{team_name} if necessary"
team_id = create_team(team_name, token)

log "Retrieving current roster (if it exists)"
current_roster = get_roster(team_id, token)
optimized_current_roster = optimize_current_roster(current_roster)

# Load a CSV for the team
log "Reading CSV"
CSV.foreach(csv_file, headers: true) do |row|

  if row['Selected'] == 'Y'

    # Add players to the Team
    roster_data = {"roster" =>
                       {"first" => row['First'],
                        "last" => row['Last'],
                        "birthdate" => row['Birthdate'],
                        "gender" => (row['Gender'] == 'Boys' ? 'Male' : 'Female'),
                        "roster_email_addresses_attributes" =>
                            [
                                {
                                    "label" => "#{row['Parent1 First']} #{row['Parent1 Last']}",
                                    "email" => row['Parent1 Email'],
                                    "receive_team_emails" => true
                                }
                            ],
                        "roster_telephones_attributes" =>
                            [
                                {
                                    "label" => "#{row['Parent1 First']} #{row['Parent1 Last']}'s Cell",
                                    "phone_number" => row['Parent1 Cell'],
                                    "enable_sms" => false,
                                    "hide" => false,
                                    "sms_carrier" => ''
                                }
                            ],
                        'contacts_attributes' =>
                            [
                            ],
                       }
    }

    # Add parent contacts
    [2].each do |parent_id|

      parent_first = row["Parent#{parent_id} First"]
      if not parent_first.nil? and not parent_first.empty?

        parent_last = row["Parent#{parent_id} Last"]
        parent_email = row["Parent#{parent_id} Email"]
        parent_cell = row["Parent#{parent_id} Cell"]

        # create json
        parent =  {
            "first" => parent_first,
            "last" => parent_last,
            "contact_email_addresses_attributes" => [

            ],
            "contact_telephones_attributes" =>  [
            ]}

        if parent_email && !parent_email.empty?
          parent['contact_email_addresses_attributes'] << {
              "label" => "#{parent_first} #{parent_last}",
              "email"=> parent_email,
              "receive_team_emails"=> true,
              "hide"=> false
          }
        end

        if parent_cell && !parent_cell.empty?
          parent['contact_telephones_attributes'] << {
              "label" => "#{parent_first} #{parent_last}'s Cell",
              "phone_number" => parent_cell,
              "preferred" => false,
              "enable_sms" => false,
              "sms_carrier" => "",
              "hide" =>false
          }

        end

        roster_data['roster']['contacts_attributes'] << parent
      end
    end

    # only create the roster entry if it doesn't already exist
    if not roster_exists?(optimized_current_roster, roster_data)
      create_roster(roster_data, team_id, token)
    end
  end
end

# Invite Parents to join the team

