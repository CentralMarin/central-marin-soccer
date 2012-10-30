# spec/factories/coach.rb
require 'faker'

FactoryGirl.define do
  factory :coach do |f|
    f.name { Faker::Name.first_name + ' ' + Faker::Name.last_name }
    f.email { Faker::Internet.email }
    f.bio { Faker::Lorem.paragraphs }
  end
end
