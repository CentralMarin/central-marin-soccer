require "net/https"
require 'uri'
require 'json'
require 'csv'
require 'pathname'

DIVISION_ID = 3271
SEASON = 2014
ROSTER_ID = '1893703'

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

  # Check if the team already exists
  response = http_get('https://api.teamsnap.com/v2/teams',
                      {
                          'Content-Type' =>  'application/json',
                          'X-Teamsnap-Token' => token
                      })
  JSON.parse(response.body).each do |team|
    if team['team']['team_name'] == name
      return team['team']['id']
    end
  end

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

def create_roster(roster_data, team_id, token)
  # TODO: If the player already exists, skip them
  response = http_post("https://api.teamsnap.com/v2/teams/#{team_id}/as_roster/#{ROSTER_ID}/rosters",
    {
      'Content-Type' =>  'application/json',
      'X-Teamsnap-Token' => token
    },
    roster_data)
  #if response.code == '200'
  #  # Add the phone numbers for contacts
  #  results = JSON.parse(response.body)
  #  roster_id = results['roster']['id']
  #  results['roster']['contacts'].each do |contact|
  #    # Determine which contact we have and update the telelphone number
  #    roster_data['roster']['contacts_attributes'].each do |source_contact|
  #      if source_contact['first'] == contact['first'] && source_contact['last'] == contact['last']
  #        # update the telelphone number
  #        id = contact['id']
  #
  #        foo = http_get("https://api.teamsnap.com/v2/teams/#{team_id}/as_roster/#{ROSTER_ID}/rosters/#{roster_id}/contacts/#{id}",
  #                       {
  #                           'Content-Type' =>  'application/json',
  #                           'X-Teamsnap-Token' => token
  #                       })
  #        foo1 = http_get("https://api.teamsnap.com/v2/teams/#{team_id}/as_roster/#{ROSTER_ID}/rosters/#{roster_id}/contacts",
  #                       {
  #                           'Content-Type' =>  'application/json',
  #                           'X-Teamsnap-Token' => token
  #                       })
  #
  #
  #        response_telephone = http_put("https://api.teamsnap.com/v2/teams/#{team_id}/as_roster/#{ROSTER_ID}/rosters/#{roster_id}/contacts/#{id}",
  #                                       {
  #                                           'Content-Type' =>  'application/json',
  #                                           'X-Teamsnap-Token' => token
  #                                       },
  #                                       {
  #                                           'contact' =>
  #                                              {
  #                                                  'contact_telephone_numbers_attributes' =>
  #                                                      [
  #                                                          {
  #                                                              'phone_number' => '415-258-9079'
  #                                                          }
  #                                                      ]
  #                                              }
  #                                       }
  #        )
  #
  #        i = 10
  #      end
  #    end
  #  end
  #else
  #  puts "Unable to create roster entry for #{token['roster']['first']} #{token['roster']['last']}"
  #  exit(-1)
  #end

  code = response.code

end

# Grab User Name and Password from the command line
if ARGV.length != 3
  puts 'Usage: Setup.rb <user> <pwd> <csv file>'
  exit(-1)
end
user = ARGV[0]
pwd = ARGV[1]
csv = ARGV[2]

# Parse the filename for the name of the team replacing underscore characters with spaces
team_name = File.basename(ARGV[2], '.csv').gsub!('_', ' ')

# Login to TeamSnap
token = authenticate(user, pwd)
if token.nil?
  puts "Invalid user name or password"
  exit -1
end

# Create the Team
team_id = create_team(team_name, token)

# Load a CSV for the team
CSV.foreach(ARGV[2], headers: true) do |row|

  # TODO: Add parent 1 info for the child (if the child is too young)
  # TODO: Add parent 1 as the first contact and parent 2 as the second (if exists)
  # TODO: Update the home address for all registrations
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
                                    "label" => "#{row['Parent1 First']} #{row['Parent1 Last']}'s' Cell",
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
                {
                    "label" => "#{parent_first} #{parent_last}",
                    "email"=> parent_email,
                    "receive_team_emails"=> true,
                    "hide"=> false
                },
            ],
            "contact_telephones_attributes" =>  [
                {
                    "label" => "#{parent_first} #{parent_last}'s Cell",
                    "phone_number" => parent_cell,
                    "preferred" => false,
                    "enable_sms" => false,
                    "sms_carrier" => "",
                    "hide" =>false
                }
            ]}

        roster_data['roster']['contacts_attributes'] << parent
      end
    end


    create_roster(roster_data, team_id, token)
  end
end

# Invite Parents to join the team

