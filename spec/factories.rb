FactoryGirl.define do
  factory :parent_two, :class => Parent do
    name          'Joe Smith'
    email         'joe@smith.net'
    home_phone    '415-123-1234'
    cell_phone    '415-987-9876'
  end

  factory :parent_one, :class => Parent do
    name          'Jane Smith'
    email         'jane@smith.net'
    home_phone    '415-123-1234'
    cell_phone    '415-987-9876'
  end

  factory :coach do
    name           'Test Coach'
    email          'test@coach.com'
    bio            'I was born a poor soccer child ...'
  end

  factory :field do
    name            'Test Field'
    club            'Test Club'
    rain_line       '098-765-4321'
    address         '54 St John RoadFort Kent, ME 04743'
    state_id        0
  end

  factory :team_level do
    name      'test level'
  end

  factory :player do
    first_name    'Jane'
    last_name     'Doe'
  end

  factory :admin_role, :class => Role do
    name          'admin'
  end

  factory :manager_role, :class => Role do
    name          'manager'
  end

  factory :admin_user, :class => AdminUser do
    email         'ryan@robinett.org'
    password      'password'
  end
end