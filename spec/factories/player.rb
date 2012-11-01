# spec/factories/player.rb
require 'faker'

FactoryGirl.define do
  factory :player do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.parents { [FactoryGirl.create(:parent), FactoryGirl.create(:parent)] }
  end
end
