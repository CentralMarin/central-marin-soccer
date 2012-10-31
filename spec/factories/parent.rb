# spec/factories/parent.rb
require 'faker'

FactoryGirl.define do
  factory :parent do |f|
    f.name { Faker::Name.name }
    f.email { Faker::Internet.email }
    f.home_phone { Faker::PhoneNumber.cell_phone }
    f.cell_phone { Faker::PhoneNumber.cell_phone }
  end
end
