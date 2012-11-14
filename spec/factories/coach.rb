# spec/factories/coach.rb
require 'faker'

FactoryGirl.define do
  factory :coach do |f|
    f.name { Faker::Name.name }
    f.email { Faker::Internet.email }
    f.bio { Faker::Lorem.paragraphs.join().gsub('\n', ' ').squeeze(' ') }
  end
end
