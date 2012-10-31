# spec/factories/team_level.rb
require 'faker'

FactoryGirl.define do
  factory :team_level do |f|
    f.name { Faker::Company.name }
  end
end
