class Tryout < ActiveRecord::Base
  belongs_to :field

  validates :gender_id, :presence => true
  validates :age, :presence => true
  validates :field, :presence => true

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
      "#{start.strftime('%a %b')} #{start.day.ordinalize} #{start.strftime('%l:%M')} - #{(start + (duration * 60)).strftime('%l:%M')}"
    end
  end

  def to_s
    display_string = "U#{age} #{gender} #{date_to_s} "
    if (not field.nil?)
      display_string += " @ #{field.name} - #{field.address}"
    end
  end

  def self.tryouts_for_age_and_gender(age, gender)
    if age < 10
      age = 9
    end

    key = self.tryout_name(age, gender)

    tryouts = {key => []}
    Tryout.where(age: age).where(gender_id: gender.id).order('start').each do |tryout|
      tryouts[key].push tryout
    end

    tryouts
  end

  def self.tryout_name(age, gender)
    key = ""
    if age < 10
      key = "#{gender} Academy"
    else
      key = "#{gender} U#{age}"
    end
    key
  end

  def self.calculate_age_level(month, year)

    age_level = Time.now.year - year + 1;
    if month > 7
      age_level = age_level - 1
    end

    age_level
  end

  def self.by_age_and_gender
    # Combine age and gender tryouts
    tryouts = {}
    Tryout.order('age, gender_id, start').each do |tryout|
      key = self.tryout_name(tryout.age, tryout.gender)

      if tryouts.has_key?(key)
        tryouts[key].push tryout
      else
        # add entry to array
        tryouts[key] = [tryout]
      end
    end

    return tryouts
  end

  def as_json(options = {})
    { gender: Gender.new(self.gender_id).name, age: self.age, date: self.date_to_s, field: field.as_json  }
  end
end
