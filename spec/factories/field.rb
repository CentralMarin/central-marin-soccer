# spec/factories/field.rb
require 'faker'

FactoryGirl.define do
  factory :field do |f|
    f.name { Faker::Company.name }
    f.club { Faker::Company.catch_phrase }
    f.rain_line { Faker::PhoneNumber.phone_number }
    f.status { rand(3) }
    f.lat { Faker::Address.latitude }
    f.lng { Faker::Address.longitude }
    f.address { Faker::Address.street_address }
  end
end
