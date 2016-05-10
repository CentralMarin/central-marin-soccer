class PlayerPortalSelectedEvent < ActiveRecord::Base
  has_many :player_portals
  has_many :event_details
end
