class EventDetail < ActiveRecord::Base

  belongs_to :event
  belongs_to :location

  validates :start, :presence => true
  validates :duration, :presence => true
  validates :location, :presence => true

  bitmask :groups, :as => [:U19_Boys, :U18_Boys, :U17_Boys, :U16_Boys, :U15_Boys, :U14_Boys, :U13_Boys, :U12_Boys,
               :U11_Boys, :U10_Boys, :U9_Boys, :U8_Boys, :U19_Girls, :U18_Girls, :U17_Girls, :U16_Girls,
               :U15_Girls, :U14_Girls, :U13_Girls, :U12_Girls, :U11_Girls, :U10_Girls, :U9_Girls, :U8_Girls]

  def formatted_start=(start)
    self.start = DateTime.strptime(start, '%m/%d/%Y %H:%M')
  end

  def formatted_start
    "#{self.start.strftime('%m/%d/%Y %H:%M')}" unless self.start.nil?
  end

  def date_to_s
    "#{I18n.localize(start, format: '%a %b')} #{I18n.locale == :en ? start.day.ordinalize : start.day} #{start.strftime('%l:%M')} - #{(start + (duration * 60)).strftime('%l:%M')}" unless self.start.nil?
  end

  def to_s
    # "U#{age} #{gender} #{date_to_s} @ #{field.name} - #{field.address}"

    "#{values_for_groups.to_s} #{date_to_s} @ #{location.name} - #{location.address}"
  end
end

# Group by age ranges (so we can say U9 - U12)