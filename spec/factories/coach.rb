# spec/factories/coach.rb
require 'faker'

FactoryGirl.define do
  factory :coach do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    bio { Faker::Lorem.paragraphs.join().gsub('\n', ' ').squeeze(' ') }
  end
end
