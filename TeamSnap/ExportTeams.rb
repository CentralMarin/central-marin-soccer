
require './TeamSnap'


######################################################################################

# Grab User Name and Password from the command line
if ARGV.length != 3
  puts 'Usage: ExportTeams.rb <user> <pwd> <csv file>'
  exit(-1)
end

user = ARGV[0]
pwd = ARGV[1]
csv_file = ARGV[2]

# Login to TeamSnap
log "Logging into TeamSnap as user: #{user}"
token = authenticate(user, pwd)
if token.nil?
  log "Invalid user name or password"
  exit -1
end

# create the CSV
CSV.open(csv_file, "wb") do |csv|
  csv << ['Full Name', 'Name', 'Team level', 'Year', 'Gender', 'Coach', 'Teamsnap team']

  # Get all of the teams
  JSON.parse(get_teams(token).body).each do |teams|
    team = teams['team']
    if team['division_id'] != nil and team['division_id'] == 3271
      log "Processing team #{team['team_name']}"

      # parse the name
      team_name = team['team_name'].downcase()

      # Figure out gender
      gender = 'Girls'
      final_team_name = 'Magic'
      if team_name.include? 'boys'
        gender = 'Boys'
        final_team_name = 'Arsenal'
      end

      # Figure out year
      year_string = team_name.match(/'(\d\d)/i)
      year = nil
      if (year_string != nil && year_string.length > 1)
        # pull off the year found
        partial_year = year_string[1]

        if (partial_year.to_i > 90)
          year = "19#{partial_year}".to_i
        else
          year = "20#{partial_year}".to_i
        end
      end

      # Pull Team Level - pool or blank
      level = ''
      case team_name
        when /academy/
          level = 'Academy'
        when /pool/
          level = 'Pool'
        when /united/
          level = 'United'
        when /blue/
          level = 'Blue'
        when /red/
          level = 'Red'
        when /white/
          level = 'White'
      end

      coach = ''
      # Pull rosters to find any non-players labeled coach
      roster = get_roster(team['id'], token)
      roster.each do |roster|
        player = roster['roster']
        if player['non_player']
          position = player['position'].downcase()
          if position.include? 'coach'
            coach = "#{coach}#{', ' unless coach.empty?}#{player['first']} #{player['last']}"
          end
        end
      end

      csv << [team_name, final_team_name, level, year, gender, coach, team['id']]
    end
  end
end

