class Event < ActiveRecord::Base

  TRYOUT_YEAR = 2016
  MIN_AGE = 7
  MAX_AGE = 19

  enum category: { tryout: 1, meeting: 2, training: 3 }

  active_admin_translates :title, :description

  has_many :event_details
  accepts_nested_attributes_for :event_details, :allow_destroy => true

  validates :category, :presence => true
  validates :title, :presence => true
  validates :description, :presence => true

  def self.age(year)
    TRYOUT_YEAR - year + 1
  end

  def age_specific_details(sex, birthday)
    age = "U#{Event.age(birthday.year)}".to_sym
    details = nil
    if sex == 'Boys'
      details = event_details.with_boys_age_groups(age)
    else
      details = event_details.with_girls_age_groups(age)
    end

    # only return events in the future
    now = Time.now
    details.select{|x| x.start.nil? || x.start >= now}
  end

  def by_age_groups
    boys = {}
    girls = {}

    event_details.each do |detail|
      age_groups(boys, detail, detail.boys_age_groups) {|age_group| detail.boys_age_groups?(age_group) }
      age_groups(girls, detail, detail.girls_age_groups) {|age_group| detail.girls_age_groups?(age_group) }
    end

    [boys, girls]
  end

  def by_age_ranges
    boys, girls = by_age_groups
    new_boys = {}
    new_girls = {}


    EventDetail::AGE_GROUPS.each do |current_age|
      group_age_ranges(new_boys, boys, current_age)
      group_age_ranges(new_girls, girls, current_age)
    end

    [new_boys, new_girls]
  end

  protected

  def group_age_ranges(result, group, current_age)
    ages = []
    current_details = group[current_age]
    unless current_details.nil?
      group[current_age] = nil # Clear the result since we've processed it
      ages << current_age

      # Let's find if we have any matches
      group.each do |age, details|
        if current_details == details
          ages << age
          group[age] = nil
        end
      end

      # Convert array of ages to string of age ranges
      result[EventDetail.to_ranges(ages)] = current_details.sort! {|a,b| a.start <=> b.start }
    end
  end

  def age_groups(groups, detail, ages, &block)
    ages.each do |age|
      if yield(age)
        groups[age] = [] if groups[age].nil?
        groups[age] << detail
      end
    end
  end
end
