# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :web_part do |f|
    f.name { Faker::Name.name }
    f.html { Faker::Lorem.paragraphs.join().gsub('\n', ' ').squeeze(' ') }
  end
end
