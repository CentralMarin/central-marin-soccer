class EventRegistration < ActiveRecord::Base

  belongs_to :player_portal
  belongs_to :event_detail
end
