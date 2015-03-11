class EventDetail < ActiveRecord::Base

  belongs_to :event
  belongs_to :location

  validates :start, :presence => true
  validates :duration, :presence => true
  validates :location, :presence => true

  def formated_start=(start)
    self.start = DateTime.strptime(start, '%m/%d/%Y %H:%M')
  end

  def formated_start
    "#{self.start.strftime('%m/%d/%Y %H:%M')}" unless self.start.nil?
  end

  def date_to_s
    "#{I18n.localize(start, format: '%a %b')} #{I18n.locale == :en ? start.day.ordinalize : start.day} #{start.strftime('%l:%M')} - #{(start + (duration * 60)).strftime('%l:%M')}" unless self.start.nil?
  end

  def to_s
    # "U#{age} #{gender} #{date_to_s} @ #{field.name} - #{field.address}"
    "#{date_to_s} @ #{location.name} - #{location.address}"
  end

end
