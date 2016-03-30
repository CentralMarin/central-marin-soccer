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

  def to_s
    # TODO: Would be nice to condense the range if more than one
    boys = girls = ''
    boys = "#{I18n.t('team.gender.boys')} #{boys_age_groups.join(', ')}" if boys_age_groups?
    girls = "#{I18n.t('team.gender.girls')} #{girls_age_groups.join(', ')}" if girls_age_groups?
    "#{boys}#{boys.present? && girls.present? ? ' & ' : ''}#{girls} #{I18n.l start} @ #{location.name}"
  end
end
