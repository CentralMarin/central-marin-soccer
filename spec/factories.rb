FactoryGirl.define do
  factory :admin_user, :class => User do
    email 'ryan@robinett.org'
    password  'password'
  end
end