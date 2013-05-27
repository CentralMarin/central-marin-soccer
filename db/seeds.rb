# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

ENV = {}
config = YAML.load(File.read(File.expand_path('../../config/application.yml', __FILE__)))
config.merge! config.fetch(Rails.env, {})
config.each do |key, value|
  ENV[key] = value.to_s unless value.kind_of? Hash
end

# Updates / creates coaches based on email address
def coach_create(details)
  coach = Coach.find_by_email(details[:email])
  teams = details.delete(:coached_teams)
  if coach.nil?
    coach = Coach.create(details)
  else
    coach.assign_attributes(details)
  end

  if Rails.env != 'production'
    I18n.available_locales.each do |locale|
      I18n.locale = locale
      coach.bio = Faker::Lorem.paragraphs(5) if coach.bio.nil?
    end
    coach.save
  end

  I18n.locale = :en
  if not teams.nil?
    Team.delete_all(["coach_id = ?", coach.id])
    teams.each do |team|
      team[:coach_id] = coach.id
      team[:team_level_id] = team.delete(:team_level).id
      Team.create(team)
    end
  end
end

# Assumes if team level already exists, no need to update it
def team_level_create(english, spanish)
  team = TeamLevel.find_by_name(english)
  return team unless team.nil?

  I18n.locale = :en
  team = TeamLevel.create(name: english)
  I18n.locale = :es
  team.name = spanish
  team.save

  # Always switch back to English
  I18n.locale = :en
  return team
end

# Assumes if field name already exists, no need to create
# TODO: allow the other fields to be updated
def field_create(details)
  field = Field.find_by_name(details[:name])

  if field.nil?
    field = Field.create(details)
  else
    field.assign_attributes(details)
  end

  field
end

team_level_premier = team_level_create('Premier', 'Primero')
team_level_gold = team_level_create('Gold', 'Oro')
team_level_silver = team_level_create('Silver', 'Plata')
team_level_bronze = team_level_create('Bronze', 'Bronce')
team_level_academy = team_level_create('Academy', 'Academia')
team_level_blank = team_level_create('', '')

field_create(name: 'Edna McGuire Elementary School', club: 'Mill Valley', rain_line: '383-7818', address: '80 Lomita Dr. Mill Valley, CA 94941', status: 0)
field_create(name: 'Bacich School', club: 'Kentfield/Ross valley', rain_line: '721-1965', address: '699 Sir Francis Drake Blvd., Kentfield, CA 94904', status: 0)
field_create(name: 'Bayfront Park', club: 'Mill Valley', rain_line: '383-7818', address: 'Bayfront Park, Sycamore Avenue, Mill Valley, CA', status: 0)
field_create(name: 'Bel Aire School', club: 'Tiburon', rain_line: '789-TILT', address: '277 Karen Way, Tiburon CA, 94920', status: 0)
sleep 1
field_create(name: 'Branson School', club: 'Ross', rain_line: '', address: '39 Fernhill Avenue, Ross, CA', status: 0)
field_create(name: 'College of Marin', club: 'Kentfield/Ross valley', rain_line: '485-9554', address: '855 College Ave, Kentfield, CA 94904', status: 0)
field_create(name: 'Creekside (McInnis Park South Field)', club: 'San Rafael', rain_line: '499-6387', address: '350 Smith Ranch Rd, San Rafael, CA 94903', status: 0)
field_create(name: 'Davidson Middle School', club: 'San Rafael', rain_line: '485-2246', address: '280 Woodland Avenue, San Rafael, CA', status: 0)
sleep 1
field_create(name: 'Del Mar Intermediate School', club: 'Tiburon', rain_line: '789-TILT', address: '105 Avenida Miraflores , Tiburon, CA', status: 0)
field_create(name: 'Drake High School', club: 'San Anselmo', rain_line: '', address: '1327 Sir Francis Drake Boulevard, San Anselmo, CA, 94960', status: 0)
field_create(name: 'Dominican University', club: 'San Rafael', rain_line: '482-3500', address: 'Conlan Recreation Center Dominican University of California, San Rafael, CA 94901', status: 0)
field_create(name: 'Friends Field', club: 'Mill Valley', rain_line: '383-7818', address: '180 Camino Alto, Mill Valley, California', status: 0)
sleep 1
field_create(name: 'The Mountain School', club: 'Corte Madera/Tiburon club', rain_line: '789-TILT', address: '50 El Camino Drive, Corte Madera, CA', status: 0)
field_create(name: 'Hall Middle School', club: 'Corte Madera', rain_line: '', address: 'Hall Middle School, Doherty Drive, Larkspur, CA', status: 0)
field_create(name: 'East Hauke', club: 'Mill Valley', rain_line: '383-7818', address: '1 Hamilton Dr, Mill Valley, CA 94941', status: 0)
field_create(name: 'South Hauke', club: 'Mill Valley', rain_line: '383-7818', address: '498 sycamore ave, Mill Valley, CA', status: 0)
sleep 1
field_create(name: 'Kent Middle School', club: 'Kentfield/Ross valley', rain_line: '721-1965', address: '800 College Avenue, Kentfield, CA 94904', status: 0)
field_create(name: 'Marin Academy', club: 'Tiburon', rain_line: '789-TILT', address: '1600 Mission Ave, San Rafael, CA 94901', status: 0)
field_create(name: 'Marin Catholic High School', club: 'Kentfield', rain_line: '', address: '675 Sir Francis Drake Boulevard, Kentfield, CA', status: 0)
field_create(name: 'McKegney Field', club: 'Tiburon', rain_line: '789-TILT', address: 'McKegney Field, Tiburon, CA 94920', status: 0)
sleep 1
field_create(name: 'Miller Creek', club: 'San Rafael/Dixie', rain_line: '472-4686', address: '2255 Las Gallinas Avenue, San Rafael, CA 94903', status: 0)
field_create(name: 'Nike (McInnis Park North Field)', club: 'San Rafael', rain_line: '499-6387', address: '350 Smith Ranch Rd, San Rafael, CA 94903', status: 0)
field_create(name: 'Pickleweed', club: 'San Rafael', rain_line: '485-3077', address: '50 Canal St, San Rafael, CA 94901', status: 0)
field_create(name: 'Piper Park', club: 'Larkspur', rain_line: '927-5035 3#', address: 'Piper Park, Doherty Drive, Larkspur, CA', status: 0)
sleep 1
field_create(name: 'Redhill Park', club: 'San Anselmo', rain_line: '', address: 'Red Hill Community Park, San Anselmo, CA', status: 0)
field_create(name: 'Redwood High School', club: 'Larkspur', rain_line: '945-3607', address: '395 Doherty Drive, Larkspur, CA 94939', status: 0)
field_create(name: 'Ross Common', club: 'Kentfield/Ross valley', rain_line: '721-1965', address: 'Ross Common, Ross, CA', status: 0)
field_create(name: 'San Rafael High School', club: 'San Rafael', rain_line: '', address: '185 Mission Ave, San Rafael, CA 94901', status: 0)
sleep 1
field_create(name: 'St. Marks', club: 'San Rafael/Dixie', rain_line: '472-4686', address: '39 Trellis Drive, San Rafael, CA 94903', status: 0)
field_create(name: 'Tamalpais High School', club: 'Mill Valley', rain_line: '945-3607', address: '700 Miller Avenue, Mill Valley, CA 94941', status: 0)
field_create(name: 'Terra Linda High School', club: 'San Rafael', rain_line: '', address: '320 Nova Albion Way, San Rafael, CA 94903', status: 0)
field_create(name: 'Town Park', club: 'Corte Madera', rain_line: '927-5076', address: '498 Tamalpais Drive, Corte Madera, CA 94924', status: 0)
sleep 1
field_create(name: 'Vallecito (V2)', club: 'San Rafael/Dixie', rain_line: '472-4686', address: 'Vallecito Elementary School, San Rafael, CA, 94903', status: 0)
field_create(name: 'Venetia Valley', club: 'San Rafael', rain_line: '485-2246', address: '177 North San Pedro Road, San Rafael, CA 94903', status: 0)

coach_create(name: 'Steven Sosa', email: 'steven.sosa@centralmarinsoccer.com',
             coached_teams: nil
)

coach_create(name: 'Joey Garcia', email: 'joey.garcia@centralmarinsoccer.com',
             coached_teams: nil
)

coach_create(name: 'Craig Breslin', email: 'craig.breslin@centralmarinsoccer.com',
             coached_teams: [
                 {year: 2005, gender: 'Boys', team_level: team_level_blank, name: 'Academy Pool', teamsnap_team_id: '149840'},
                 {year: 2002, gender: 'Boys', team_level: team_level_gold, name: 'Pool', teamsnap_team_id: '149846'},
                 {year: 2001, gender: 'Boys', team_level: team_level_gold, name: 'Pool', teamsnap_team_id: '149849'}
             ]
)
coach_create(name: 'Mike Crivello', email: 'mike.crivello@centralmarinsoccer.com',
             bio: "Mike Crivello has been coaching at Central Marin since 2008.  Over the last 5 years he has coached various age groups from the U9 Academy to U13's.  Currently he is the U10 Boys Gold Coach and will assist Jeff Troyer with the U14 boys.  Mike is also the Head Varsity Boys Coach at Terra Linda High School and the trainer for the Terra Linda Varsity Girls team.  Mike's coaching licenses include a National and Advanced National Diploma from the NSCAA and he looks to attain his B license from US Soccer in the next year.  Mike grew up in Terra Linda and played youth soccer for the Dixie Stompers.  He attended Terra Linda High School and went on to play for the legendary Steve Negoesco at the University of San Francisco.  Mike was a two year starter at USF and a two time All-League selection in the West Coast Conference.  Mike has a Bachelors Degree in Business Administration and a Master's Degree in Sports Management from USF.  He currently lives in Terra Linda and works at US Sports Camps.",
             coached_teams: [
                 {year: 2004, gender: 'Boys', team_level: team_level_blank, name: 'Pool', teamsnap_team_id: '149842'}

             ]
)

coach_create(name: 'Rob Neville', email: 'rob.neville@centralmarinsoccer.com',
             coached_teams: nil
)

coach_create(name: 'Gareth Owen', email: 'gareth.owen@centralmarinsoccer.com',
             coached_teams: nil
)

coach_create(name: 'Kelly Coffey', email: 'kelly.coffey@centralmarinsoccer.com',
             bio:
                 "Kelly Coffey has coached for Central Marin for 4 seasons focussing on developing our top gold level teams.  He is in his sixth season as a member of the Gator men's soccer coaching staff. Coffey came to SF State in the Spring of 2007 from the College of Marin where he was the Head Men's Soccer Coach and an instructor in the Physical Education department since 2003.  While at the College of Marin, Coffey also was also the Assistant Women's Soccer Coach from 2006-07. In addition to his role with the Gators, Coffey is a staff coach with the Marin Football Club as well as an evaluator for the Region IV Olympic Development Program.<br>" +
                "<br>" +
                "Prior to taking over the Men's Soccer program at the College of Marin, Coffey was the Assistant Coach for the Men at the University of San Francisco from 2002 to 2003 and was a staff coach for the Novato Youth Soccer Association select program for 3 years. Before the University of San Francisco, Coffey was the Head Varsity boy's coach at Quantico High School in 2001 in Quantico, Virginia.<br>" +
                "<br>" +
                "Coffey has a USSF National ""A"" license as well as an NSCAA Advanced National Diploma. He received his Bachelor's Degree from Mary Washington College in Fredericksburg, Virginia, where he was a starter for the men's soccer team for four years and was the Team Captain from 1998 to 2000. He also was the 1999 Team MVP and a two-time member of the All-Conference Team. Coffey played a key role in Mary Washington College receiving a bid for two straight years to the National Tournament including making the final four and finishing third in the nation in 1997. Coffey received his Master's Degree from the University of San Francisco in 2003.<br>",
             coached_teams: [
                 {year: 2003, gender: 'Boys', team_level: team_level_blank, name: 'Pool', teamsnap_team_id: '149844'}
             ]
)

coach_create(name: 'Phil Billeci-gard', email: 'phil.billeci-gard@centralmarinsoccer.com',
             bio: "<p>After playing and coaching in Holland, Billeci-Gard has returned to the Bay Area and Dominican University of California. He has coached for 12 years, starting as a youth instructor at Graff Willem VAC in Den Hagg, Holland. Following one season as an assistant coach at Santa Rosa Junior College, Billeci-Gard became the Assocaite Men's and Women's Head Soccer Coach at Dominican Univeristy.  In addition to Dominican, Billeci-Gard currently coaches at Marin FC, and Central Marin soccer clubs. In college, Billeci-Gard was a two-time all-conference player, one year for Dominican, who returned to Dominican to coach Dominican's women's team with Delano in 2006.</p>" +
                  "<p>Billeci-Gard's playing career extends from De La Salle High School in Concord, Calif., to Southern Oregon, to Reno, Nev. where he played for the Northern Nevada Aces, a Division 3 professional team. He also competed in the United States Developmental Player League for a year</p>." +
                  "<p>Billeci-Gard, has his BA in English from Dominican and is currently enrolled in its MBA program. He and his wife Megan and son Franklin reside in San Rafael with their two cats. He enjoys exotic fish and real estate in his off time.</p>",
             coached_teams: nil
)

coach_create(name: 'Tom Ryan', email: 'tom.ryan@centralmarinsoccer.com',
             bio: "Tom Ryan been coaching at the high school level for 30 years. Currently in his 24th year at Branson coaching both boys and girls varsity soccer. I also have worked at the club level for 20 years working for Tiburon, Marin F.C. and Central Marin. He holds a USSF B license and is a member of the Marin Athletic Foundation Hall of Fame. Two years ago he completed his 4th year with the U16 boys, handing them over last year to take on the U-10 boys silver team,  and really enjoyed the experience.  ""I am looking forward to another great season with Central Marin"" .",
             coached_teams: nil
)

coach_create(name: "Tighe O'sullivan", email: "tighe.o'sullivan@centralmarinsoccer.com",
             coached_teams: [
                 {year: 2002, gender: 'Boys', team_level: team_level_silver, name: 'Pool', teamsnap_team_id: '149847'}
             ]
)

coach_create(name: 'Jeff Troyer', email: 'jeff.troyer@centralmarinsoccer.com',
             coached_teams: [
                 {year: 2001, gender: 'Boys', team_level: team_level_silver, name: 'Pool', teamsnap_team_id: '149850'}
             ]
)

coach_create(name: 'Brandon Murphy', email: 'brandon.murphy@centralmarinsoccer.com',
             bio: "Marin catholic 91'<br>" +
                  "Humboldt state university 96'<br>" +
                  "Head coach marin catholic boys/girls varsity/jv 1997-2006<br>" +
                  "Head coach redwood boys varsity 2006-2012<br>" +
                  "Head coach novato youth soccer association 1998-2004<br> " +
                  "Head coach marin fc 2004-2009<br>" +
                  "Head coach central marin soccer club 2005-present<br>" +
                  "USSF national D<br>" +
                  "NSCAA national diploma<br>" +
                  "<br>Favorite player of all time is zinedine zidane<br>" +
                  "<br>Assistant manager at demosport ski shop<br>" +
                  "<br>When not coaching i like to ride surfboards and snowboards and to travel<br>",
             coached_teams: [
                 {year: 2005, gender: 'Girls', team_level: team_level_blank, name: 'Academy Pool', teamsnap_team_id: '149839'},
                 {year: 2004, gender: 'Girls', team_level: team_level_blank, name: 'Pool', teamsnap_team_id: '149841'},
                 {year: 2001, gender: 'Girls', team_level: team_level_blank, name: 'Pool', teamsnap_team_id: '149848'}
             ]
)

coach_create(name: 'Jodi Lingafeldt', email: 'jodi.Lingafeldt@centralmarinsoccer.com',
             bio: "Played for San Juan Soccer Club (Sacramento), CSU Sacramento NCAA Div. 1, Sonoma State University NCAA Div. 2<br>" +
                  "Coached with Santa Rosa United (7 yrs), Central Marin & Marin FC (5 yrs), Cal North ODP State Team (4 yrs), Asst. Coach Sonoma State University ('98-'00)<br>" +
                  "BS Kinesiology Athletic Training from Sonoma State University<br>" +
                  "USSF ""C"" License<br>" +
                  "NSCAA Advanced National Diploma",
             coached_teams: [
                 {year: 2004, gender: 'Girls', team_level: team_level_silver, name: '', teamsnap_team_id: ''}
             ]
)

coach_create(name: 'Jessica Jean', email: 'jessica.jean@centralmarinsoccer.com',
             coached_teams: nil
)

coach_create(name: 'Jim Lasher', email: 'jim.lasher@centralmarinsoccer.com',
             coached_teams: [
                 {year: 2003, gender: 'Girls', team_level: team_level_gold, name: '', teamsnap_team_id: '149843'},
                 {year: 2002, gender: 'Girls', team_level: team_level_gold, name: '', teamsnap_team_id: '149406'}
             ]
)

coach_create(name: 'Jon Owen', email: 'jon.owen@centralmarinsoccer.com',
             coached_teams: nil
)

coach_create(name: 'Adam Dietz', email: 'adam.dietz@centralmarinsoccer.com',
             bio: "Adam is currently coaching Terra Linda Junior Varsity Girls after coaching at Branson (Freshman/JV Boys) for the 2011 and 2012 seasons.<br>" +
                  "In 2002/2003 he began working for Dixie youth soccer coaching under 10 and under 11 select teams, both boys and girls, while finishing his Master's degree in Asian Studies.  He took a hiatus from club coaching to pursue an opportunity to teach and travel in China with his wife.  Adam went on to finish his Ph.D., also in Asian Studies, before returning to coach the u13 silver girls and u14 silver boys in 2011.<br>" +
                  "Adam grew up playing youth soccer in Terra Linda playing on the local select team.  He played goalkeeper for Terra Linda High School and for San Diego State University.<br>" +
                  "Adam lives in Petaluma with his wife and two children.<br>",
             coached_teams: [
                 {year: 2002, gender: 'Girls', team_level: team_level_silver, name: '', teamsnap_team_id: '149845'}
             ]
)

User.create(:email => ENV["DEFAULT_USER"], roles: User::ROLES) unless User.find_by_email(ENV["DEFAULT_USER"])

