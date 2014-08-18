# spec/factories/user.rb
require 'faker'

FactoryGirl.define do
  factory :admin_user do
    email "junk@robinett.org" #{ Faker::Internet.email }
    password 'password'

    # trait :all_rights do
    #   roles { [:admin] }
    # end
    #
    #trait :board_member do
    #  f.roles [User::ROLES[User::BOARD_MEMBER_ROLE_INDEX]]
    #end
    #
    #trait :team_manager do
    #  f.roles [User::ROLES[User::TEAM_MANAGER_ROLE_INDEX]]
    #end
    #
    #trait :field_manager do
    #  f.roles [User::ROLES[User::FIELD_MANAGER_ROLE_INDEX]]
    #end
    #
    #trait :coach do
    #  f.roles [User::ROLES[User::COACH_ROLE_INDEX]]
    #end
  end
end
