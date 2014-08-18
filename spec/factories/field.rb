# spec/factories/field.rb
require 'faker'

FactoryGirl.define do
  factory :field do
    name { Faker::Company.name }
    club { Faker::Company.catch_phrase }
    rain_line { Faker::PhoneNumber.phone_number }
    status { rand(3) }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    address { Faker::Address.street_address }
  end
end
