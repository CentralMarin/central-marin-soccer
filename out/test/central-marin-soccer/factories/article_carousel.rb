# spec/factories/article_carousel.rb
require 'faker'

FactoryGirl.define do
  factory :article_carousel do
    article { FactoryGirl.create(:article) }
    carousel_order { rand(5) }
  end
end

