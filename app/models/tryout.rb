class Tryout < ActiveRecord::Base
  belongs_to :field

  validates :gender_id, :presence => true
  validates :age, :presence => true

  def gender
    Gender.new(gender_id).name
  end

  def tryout_start=(start)
    if start.blank?
      self.start = nil
    else
      self.start = DateTime.strptime(start, '%m/%d/%Y %H:%M')
    end
  end

  def tryout_start
    if (start.nil?)
      ""
    else
      "#{start.strftime('%m/%d/%Y')} #{start.strftime('%H:%M')}"
    end
  end

  def date_to_s
    if (start.nil?)
      ""
    else
      "#{start.strftime('%a %b')} #{start.day.ordinalize} #{start.strftime('%l:%M')} - #{(start + (duration * 60 * 60)).strftime('%l:%M')}"
    end
  end

  def to_s
    display_string = "U#{age} #{gender} #{date_to_s} "
    if (not field.nil?)
      display_string += " @ #{field.name} - #{field.address}"
    end
  end

  def self.by_age_and_gender
    # Combine age and gender tryouts
    tryouts = {}
    Tryout.order("age, gender_id, start").each do |tryout|
      if (tryout.age < 10)
        key = "#{tryout.gender} Academy"
      else
        key = "#{tryout.gender} U#{tryout.age}"
      end

      if tryouts.has_key?(key)
        tryouts[key].push tryout
      else
        # add entry to array
        tryouts[key] = [tryout]
      end
    end

    return tryouts
  end
end
