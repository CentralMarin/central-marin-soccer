class EventDetail < ActiveRecord::Base
  belongs_to :event
  belongs_to :location

  bitmask :boys_age_groups, as: [
      :U8,
      :U9,
      :U10,
      :U11,
      :U12,
      :U13,
      :U14,
      :U15,
      :U16,
      :U17,
      :U18,
      :U19,
  ]

  bitmask :girls_age_groups, as: [
      :U8,
      :U9,
      :U10,
      :U11,
      :U12,
      :U13,
      :U14,
      :U15,
      :U16,
      :U17,
      :U18,
      :U19,
  ]
end
