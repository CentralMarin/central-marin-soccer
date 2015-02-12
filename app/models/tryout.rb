class Tryout < ActiveRecord::Base
  belongs_to :field

  validates :gender_id, :presence => true
  validates :age, :presence => true
  validates :tryout_start, :presence => true
  validates :duration, :presence => true
  validates :field_id, :presence => true
  validates :tryout_type_id, :presence => true

  belongs_to :tryout_type

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
      "#{I18n.localize(start, format: '%a %b')} #{I18n.locale == :en ? start.day.ordinalize : start.day} #{start.strftime('%l:%M')} - #{(start + (duration * 60)).strftime('%l:%M')}"
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

    age_level = 2015 - year + 1;
    if month > 7
      age_level = age_level - 1
    end

    age_level
  end

  def self.by_age_and_gender(tryout_type_name)

    result = TryoutType.where(name: tryout_type_name, show: true).first
    return nil if result.nil?

    info = {id: result.id, header: result.header, body: result.body}

    # Combine age and gender tryouts
    tryouts = {}
    Tryout.where(tryout_type_id: info[:id]).order('age, gender_id, start').each do |tryout|
      key = self.tryout_name(tryout.age, tryout.gender)

      if tryouts.has_key?(key)
        tryouts[key].push tryout
      else
        # add entry to array
        tryouts[key] = [tryout]
      end
    end

    info[:sessions] = tryouts
    return info
  end

  def self.by_tryout_type_age_and_gender
    info = []
    # Array is walked in reverse order, so put items in reverse chronological order
    ['Tryout Completed',  'Registration Night', 'Tryout', 'Pre-Tryout', 'Upcoming Tryout', 'Informational Meeting'].each do |name|
      tryout = by_age_and_gender(name)
      info.push(tryout) unless tryout.nil?
    end
    info
  end

  def as_json(options = {})
    { gender: Gender.new(self.gender_id).name, age: self.age, date: self.date_to_s, field: field.as_json  }
  end
end
