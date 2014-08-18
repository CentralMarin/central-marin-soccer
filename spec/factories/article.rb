# spec/factories/article.rb
require 'faker'

FactoryGirl.define do
  factory :article do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraphs.join().gsub('\n', ' ').squeeze(' ') }
    author { Faker::Name.name }
    category_id { rand(4) }
    image { Faker::Internet.url }
    team_id { rand(20) }
    coach_id { rand(10) }
  end
end
