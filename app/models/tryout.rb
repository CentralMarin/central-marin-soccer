class Tryout < ActiveRecord::Base
  belongs_to :field

  validates :gender_id, :presence => true
  validates :age, :presence => true
  validates :date, :presence => true
  validates :time_start, :presence => true
  validates :time_end, :presence => true
  validates :field, :presence => true

  def gender
    Gender.new(gender_id).name
  end

  def time_to_s
    "#{time_start.strftime('%l:%M')} - #{time_end.strftime('%l:%M')}"
  end

  def date_to_s
    "#{date.strftime('%a %b')} #{date.day.ordinalize}"
  end

  def to_s
    "U#{age} #{gender} #{date_to_s} #{time_to_s} @ #{field.name} - #{field.address}"
  end
end
