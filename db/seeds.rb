# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def coach_create(details)
  return if Coach.find_by_email(details[:email])

  teams = details.delete(:coached_teams)

  coach = Coach.create(details)
  I18n.available_locales.each do |locale|
    I18n.locale = locale
    coach.bio = Faker::Lorem.paragraphs(5)
  end
  coach.save

  I18n.locale = :en
  teams.each do |team|
    team[:coach_id] = coach.id
    team[:team_level_id] = team.delete(:team_level).id
    Team.create(team)
  end
end

team_level_premier = TeamLevel.create(name: 'Premier')
team_level_gold = TeamLevel.create(name: 'Gold')
team_level_silver = TeamLevel.create(name: 'Silver')
team_level_bronze = TeamLevel.create(name: 'Bronze')
team_level_academy = TeamLevel.create(name: 'Academy')
team_level_blank = TeamLevel.create(name: '')
                                                                
# Create Spanish versions
I18n.locale = :es
team_level_premier.name = 'Primero'
team_level_premier.save!
team_level_gold.name = 'Oro'
team_level_gold.save!
team_level_silver.name = 'Plata'
team_level_silver.save!
team_level_bronze.name = 'Bronce'
team_level_bronze.save!
team_level_academy.name = 'Academia'
team_level_academy.save!
I18n.locale = :en

Field.create(name: 'Edna McGuire Elementary School', club: 'Mill Valley', rain_line: '383-7818', address: '80 Lomita Dr. Mill Valley, CA 94941', status: 0)
Field.create(name: 'Bacich School', club: 'Kentfield/Ross valley', rain_line: '721-1965', address: '699 Sir Francis Drake Blvd., Kentfield, CA 94904', status: 0)
Field.create(name: 'Bayfront Park', club: 'Mill Valley', rain_line: '383-7818', address: 'Bayfront Park, Sycamore Avenue, Mill Valley, CA', status: 0)
Field.create(name: 'Bel Aire School', club: 'Tiburon', rain_line: '789-TILT', address: '277 Karen Way, Tiburon CA, 94920', status: 0)
sleep 1
Field.create(name: 'Branson School', club: 'Ross', rain_line: '', address: '39 Fernhill Avenue, Ross, CA', status: 0)
Field.create(name: 'College of Marin', club: 'Kentfield/Ross valley', rain_line: '485-9554', address: '855 College Ave, Kentfield, CA 94904', status: 0)
Field.create(name: 'Creekside (McInnis Park South Field)', club: 'San Rafael', rain_line: '499-6387', address: '350 Smith Ranch Rd, San Rafael, CA 94903', status: 0)
Field.create(name: 'Davidson Middle School', club: 'San Rafael', rain_line: '485-2246', address: '280 Woodland Avenue, San Rafael, CA', status: 0)
sleep 1
Field.create(name: 'Del Mar Intermediate School', club: 'Tiburon', rain_line: '789-TILT', address: '105 Avenida Miraflores , Tiburon, CA', status: 0)
Field.create(name: 'Drake High School', club: 'San Anselmo', rain_line: '', address: '1327 Sir Francis Drake Boulevard, San Anselmo, CA, 94960', status: 0)
Field.create(name: 'Dominican University', club: 'San Rafael', rain_line: '482-3500', address: 'Conlan Recreation Center Dominican University of California, San Rafael, CA 94901', status: 0)
Field.create(name: 'Friends Field', club: 'Mill Valley', rain_line: '383-7818', address: '180 Camino Alto, Mill Valley, California', status: 0)
sleep 1
Field.create(name: 'The Mountain School', club: 'Corte Madera/Tiburon club', rain_line: '789-TILT', address: '50 El Camino Drive, Corte Madera, CA', status: 0)
Field.create(name: 'Hall Middle School', club: 'Corte Madera', rain_line: '', address: 'Hall Middle School, Doherty Drive, Larkspur, CA', status: 0)
Field.create(name: 'East Hauke', club: 'Mill Valley', rain_line: '383-7818', address: '1 Hamilton Dr, Mill Valley, CA 94941', status: 0)
Field.create(name: 'South Hauke', club: 'Mill Valley', rain_line: '383-7818', address: '498 sycamore ave, Mill Valley, CA', status: 0)
sleep 1
Field.create(name: 'Kent Middle School', club: 'Kentfield/Ross valley', rain_line: '721-1965', address: '800 College Avenue, Kentfield, CA 94904', status: 0)
Field.create(name: 'Marin Academy', club: 'Tiburon', rain_line: '789-TILT', address: '1600 Mission Ave, San Rafael, CA 94901', status: 0)
Field.create(name: 'Marin Catholic High School', club: 'Kentfield', rain_line: '', address: '675 Sir Francis Drake Boulevard, Kentfield, CA', status: 0)
Field.create(name: 'McKegney Field', club: 'Tiburon', rain_line: '789-TILT', address: 'McKegney Field, Tiburon, CA 94920', status: 0)
sleep 1
Field.create(name: 'Miller Creek', club: 'San Rafael/Dixie', rain_line: '472-4686', address: '2255 Las Gallinas Avenue, San Rafael, CA 94903', status: 0)
Field.create(name: 'Nike (McInnis Park North Field)', club: 'San Rafael', rain_line: '499-6387', address: '350 Smith Ranch Rd, San Rafael, CA 94903', status: 0)
Field.create(name: 'Pickleweed', club: 'San Rafael', rain_line: '485-3077', address: '50 Canal St, San Rafael, CA 94901', status: 0)
Field.create(name: 'Piper Park', club: 'Larkspur', rain_line: '927-5035 3#', address: 'Piper Park, Doherty Drive, Larkspur, CA', status: 0)
sleep 1
Field.create(name: 'Redhill Park', club: 'San Anselmo', rain_line: '', address: 'Red Hill Community Park, San Anselmo, CA', status: 0)
Field.create(name: 'Redwood High School', club: 'Larkspur', rain_line: '945-3607', address: '395 Doherty Drive, Larkspur, CA 94939', status: 0)
Field.create(name: 'Ross Common', club: 'Kentfield/Ross valley', rain_line: '721-1965', address: 'Ross Common, Ross, CA', status: 0)
Field.create(name: 'San Rafael High School', club: 'San Rafael', rain_line: '', address: '185 Mission Ave, San Rafael, CA 94901', status: 0)
sleep 1
Field.create(name: 'St. Marks', club: 'San Rafael/Dixie', rain_line: '472-4686', address: '39 Trellis Drive, San Rafael, CA 94903', status: 0)
Field.create(name: 'Tamalpais High School', club: 'Mill Valley', rain_line: '945-3607', address: '700 Miller Avenue, Mill Valley, CA 94941', status: 0)
Field.create(name: 'Terra Linda High School', club: 'San Rafael', rain_line: '', address: '320 Nova Albion Way, San Rafael, CA 94903', status: 0)
Field.create(name: 'Town Park', club: 'Corte Madera', rain_line: '927-5076', address: '498 Tamalpais Drive, Corte Madera, CA 94924', status: 0)
sleep 1
Field.create(name: 'Vallecito (V2)', club: 'San Rafael/Dixie', rain_line: '472-4686', address: 'Vallecito Elementary School, San Rafael, CA, 94903', status: 0)
Field.create(name: 'Venetia Valley', club: 'San Rafael', rain_line: '485-2246', address: '177 North San Pedro Road, San Rafael, CA 94903', status: 0)

coach_create(name: 'Steven Sosa', email: 'steven.sosa@centralmarinsoccer.com',
             coached_teams: [{year: 1999, gender: 'Boys', team_level: team_level_blank, name: ''}])

coach_create(name: 'John Barnes', email: 'john.barnes@centralmarinsoccer.com',
             coached_teams: [{year: 2001, gender: 'Boys', team_level: team_level_blank, name: ''}])

coach_create(name: 'Phil Bellici-Gard', email: 'phil.bellici-gard@centralmarinsoccer.com',
             coached_teams: [{year: 2000, gender: 'Girls', team_level: team_level_blank, name: ''}])

coach_create(name: 'Craig Breslin', email: 'craig.breslin@centralmarinsoccer.com',
             coached_teams: [{year: 2002, gender: 'Boys', team_level: team_level_blank, name: 'Arsenal'},
                     {year: 2001, gender: 'Boys', team_level: team_level_blank, name: 'Arsenal'}])

coach_create(name: 'Mike Carbone', email: 'mike.carbone@centralmarinsoccer.com',
             coached_teams: [{year: 2003, gender: 'Boys', team_level: team_level_blank, name: ''}])

coach_create(name: 'Kelly Coffey', email: 'kelly.coffey@centralmarinsoccer.com',
             coached_teams: [{year: 2000, gender: 'Boys', team_level: team_level_blank, name: 'Arsenal'}])

coach_create(name: 'Mike Crivello', email: 'mike.crivello@centralmarinsoccer.com',
             coached_teams: [{year: 2000, gender: 'Boys', team_level: team_level_blank, name: 'Arsenal'}])

coach_create(name: 'Adam Dietz', email: 'adam.dietz@centralmarinsoccer.com',
             coached_teams: [{year: 1999, gender: 'Girls', team_level: team_level_blank, name: ''}])

coach_create(name: 'Sjur Hatloe', email: 'sjur.hatloe@centralmarinsoccer.com',
             coached_teams: [{year: 1997, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1996, gender: 'Boys', team_level: team_level_blank, name: ''}])

coach_create(name: 'Eamon Kavanagh', email: 'eamon.kavanah@centralmarinsoccer.com',
             coached_teams: [{year: 2003, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1998, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1998, gender: 'Girls', team_level: team_level_blank, name: ''}])

coach_create(name: 'Jim Lasher', email: 'jim.lasher@centralmarinsoccer.com',
             coached_teams: [{year: 2002, gender: 'Girls', team_level: team_level_blank, name: ''},
                     {year: 1999, gender: 'Boys', team_level: team_level_blank, name: ''}])

coach_create(name: 'Mark Machado', email: 'mark.machado@centralmarinsoccer.com',
             coached_teams: [{year: 1999, gender: 'Boys', team_level: team_level_blank}])

coach_create(name: 'Nicole Miller', email: 'nicole.miller@centralmarinsoccer.com',
             coached_teams: [{year: 2001, gender: 'Girls', team_level: team_level_blank, name: ''}])

coach_create(name: 'Brandon Murphy', email: 'brandon.murphy@centralmarinsoccer.com',
             coached_teams: [{year: 2001, gender: 'Girls', team_level: team_level_blank, name: ''},
                     {year: 1999, gender: 'Girls', team_level: team_level_blank, name: ''}])

coach_create(name: 'Brandon Romeo', email: 'brandon.romeo@centralmarinsoccer.com',
             coached_teams: [{year: 2000, gender: 'Girls', team_level: team_level_blank, name: ''}])

coach_create(name: 'Tom Ryan', email: 'tom.ryan@centralmarinsoccer.com',
             coached_teams: [{year: 1996, gender: 'Boys', team_level: team_level_blank, name: ''}])

coach_create(name: 'Jeff Troyer', email: 'jeff.troyer@centralmarinsoccer.com',
             coached_teams: [{year: 2000, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1997, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1997, gender: 'Girls', team_level: team_level_blank, name: ''},
                     {year: 1996, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1996, gender: 'Girls', team_level: team_level_blank, name: ''},
                     {year: 1995, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1995, gender: 'Girls', team_level: team_level_blank, name: ''},
                     {year: 1994, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1994, gender: 'Girls', team_level: team_level_blank, name: ''},
                     {year: 1993, gender: 'Boys', team_level: team_level_blank, name: ''},
                     {year: 1993, gender: 'Girls', team_level: team_level_blank, name: ''}])

User.create(:email => 'ryan@robinett.org', roles: User::ROLES)

