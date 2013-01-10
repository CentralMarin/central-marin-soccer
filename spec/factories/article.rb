# spec/factories/article.rb
require 'faker'

FactoryGirl.define do
  factory :article do |f|
    f.title { Faker::Lorem.sentence }
    f.body { Faker::Lorem.paragraphs }
    f.author { Faker::Name.name }
    f.category_id { rand(4) }
    f.image { Faker::Internet.url }
    f.subcategory_id { rand(20) }  # TODO: Grab a Team ID
  end
end
