FactoryGirl.define do
  factory :admin_role, :class => Role do
    name 'admin'
  end

  factory :manager_role, :class => Role do
    name 'manager'
  end

  factory :admin_user, :class => User do
    email 'ryan@robinett.org'
    password  'password'
  end
end