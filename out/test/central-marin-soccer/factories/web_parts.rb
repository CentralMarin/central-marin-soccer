# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :web_part do
    name { Faker::Name.name }
    html { Faker::Lorem.paragraphs.join().gsub('\n', ' ').squeeze(' ') }
  end
end
