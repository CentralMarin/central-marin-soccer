require "./TeamSnap"

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
CSV.foreach(csv_file, encoding: 'windows-1251:utf-8', headers: true) do |row|

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

