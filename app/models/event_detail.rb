class EventDetail < ActiveRecord::Base

  belongs_to :event
  belongs_to :field

end
