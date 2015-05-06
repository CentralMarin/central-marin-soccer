# spec/factories/team.rb
require 'faker'

FactoryGirl.define do
  factory :team do
    year { Time.now.year - (rand(10) + 9) }
    gender { rand(1) }
    name { Faker::Name.name }
    coach { FactoryGirl.create(:coach) }
    teamsnap_team_id "12345"
    team_level { FactoryGirl.create(:team_level) }
  end
end
