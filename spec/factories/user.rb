# spec/factories/user.rb
require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.email "ryan@digitalfoundry.com" #{ Faker::Internet.email }
    f.password 'password'

    trait :admin_user do
      f.roles { [User::ROLES[User::ADMIN_ROLE_INDEX]] }
    end

    #trait :board_member_user do
    #  f.roles [User::ROLES[User::BOARD_MEMBER_ROLE_INDEX]]
    #end
    #
    #trait :team_manager_user do
    #  f.roles [User::ROLES[User::TEAM_MANAGER_ROLE_INDEX]]
    #end
    #
    #trait :field_manager_user do
    #  f.roles [User::ROLES[User::FIELD_MANAGER_ROLE_INDEX]]
    #end
    #
    #trait :coach_user do
    #  f.roles [User::ROLES[User::COACH_ROLE_INDEX]]
    #end
  end
end
