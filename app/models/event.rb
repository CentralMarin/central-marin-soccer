class Event < ActiveRecord::Base
  enum type: [ :upcoming_tryout, :informational_meeting, :pre_tryout, :tryout, :registration_night, :tryout_complete ]
  enum status: [:show, :show_and_tout, :hide]

  self.inheritance_column = 'does_not_have_one'

  active_admin_translates :heading, :body, :tout

end
