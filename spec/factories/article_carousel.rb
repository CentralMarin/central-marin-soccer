# spec/factories/article_carousel.rb
require 'faker'

FactoryGirl.define do
  factory :article_carousel do |f|
    f.article { FactoryGirl.create(:article) }
    f.carousel_order { rand(5) }
  end
end

