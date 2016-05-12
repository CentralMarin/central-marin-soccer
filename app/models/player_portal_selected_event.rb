class PlayerPortalSelectedEvent < ActiveRecord::Base
  belongs_to :player_portals
  belongs_to :event_details
end
