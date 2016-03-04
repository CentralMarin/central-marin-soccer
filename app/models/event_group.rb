class EventGroup < ActiveRecord::Base

  has_many :event_details
  accepts_nested_attributes_for :event_details, :allow_destroy => true

  belongs_to :event

  bitmask :groups, :as => [:U19_Boys, :U18_Boys, :U17_Boys, :U16_Boys, :U15_Boys, :U14_Boys, :U13_Boys, :U12_Boys,
                           :U11_Boys, :U10_Boys, :U9_Boys, :U8_Boys, :U19_Girls, :U18_Girls, :U17_Girls, :U16_Girls,
                           :U15_Girls, :U14_Girls, :U13_Girls, :U12_Girls, :U11_Girls, :U10_Girls, :U9_Girls, :U8_Girls]

  before_save :set_age_ranges

  TRYOUT_YEAR = 2016
  MIN_AGE = 7
  MAX_AGE = 19

  def self.age_group(year)
    age = TRYOUT_YEAR - year + 1;

    # U18 and U19 are grouped together
    if age == 18
      age = age + 1
    end

    age
  end

  def self.age_group_name(gender, year)
    I18n.with_locale(:en) do
      "U#{self.age_group(year)}_#{gender}"
    end
  end

  protected

  # Group by gender and age ranges (so we can say Boys U9 - U12)
  def set_age_ranges
    # Loop over all the boys
    self.boys_age_range = create_age_range('Boys')

    # loop over all the girls
    self.girls_age_range = create_age_range('Girls')
  end

  def create_age_range(gender)
    age_array = []
    (8..19).each do |age|
      if groups?("U#{age}_#{gender}".to_sym)
        age_array << age
      end
    end

    # collapse ranges
    ranges = age_array.sort.uniq.inject([]) do |spans, n|
      if spans.empty? || spans.last.last != n - 1
        spans + [n..n]
      else
        spans[0..-2] + [spans.last.first..n]
      end
    end

    # create a string representation
    first_time = true
    age_range = ranges.inject("") do |display_string, range|
      if not first_time
        display_string = display_string + ', '
      else
        first_time = false
      end

      if range.min == range.max
        display_string = display_string + "#{range.min} (#{age_year(range.min)})"
      else
        display_string = display_string + "#{range.min} - #{range.max} (#{age_year(range.min)} - #{age_year(range.max)})"
      end

      display_string
    end
  end

  def age_year(age)
    TRYOUT_YEAR - age + 1
  end
end
