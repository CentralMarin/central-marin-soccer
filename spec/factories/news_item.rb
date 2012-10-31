# spec/factories/news_item.rb
require 'faker'

FactoryGirl.define do
  factory :news_item do |f|
    f.title { Faker::Lorem.sentence }
    f.body { Faker::Lorem.paragraphs }
    f.author { Faker::Name.name }
    f.carousel { rand(2) == 1 }
    f.category_id { rand(4) }
    f.image { Faker::Internet.url }
    f.subcategory_id { rand(20) }  # TODO: Grab a Team ID
  end
end
