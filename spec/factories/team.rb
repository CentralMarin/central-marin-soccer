# spec/factories/team.rb
require 'faker'

FactoryGirl.define do
  factory :team do |f|
    f.year { Time.now.year - (rand(10) + 9) }
    f.gender { rand(1) }
    f.name { Faker::Name.name }
    f.coach { FactoryGirl.create(:coach) }
    f.teamsnap_url "http://www.teamsnap.com"
    f.team_level { FactoryGirl.create(:team_level) }
  end
end