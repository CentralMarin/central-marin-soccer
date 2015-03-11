class EventDetail < ActiveRecord::Base

  belongs_to :event
  belongs_to :location

end
