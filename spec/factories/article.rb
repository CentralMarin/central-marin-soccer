# spec/factories/article.rb
require 'faker'

FactoryGirl.define do
  factory :article do |f|
    f.title { Faker::Lorem.sentence }
    f.body { Faker::Lorem.paragraphs.join().gsub('\n', ' ').squeeze(' ') }
    f.author { Faker::Name.name }
    f.category_id { rand(4) }
    f.image { Faker::Internet.url }
    f.team_id { rand(20) }
    f.coach_id { rand(10) }
  end
end
