# spec/factories/team.rb
require 'faker'

FactoryGirl.define do
  factory :team do |f|
    f.age { rand(10) + 9 }
    f.gender { rand(1) ? "Boys" : "Girls" }
    f.name { Faker::Name.name }
    f.coach { FactoryGirl.create(:coach) }
    f.team_level { FactoryGirl.create(:team_level) }
  end
end