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
    boys = {}
    girls = {}

    # Naive solution. TODO: What if an age is part of a range and by itself for different details
    event_details.each do |detail|
      age_range(boys, detail, detail.boys_age_groups)
      age_range(girls, detail, detail.girls_age_groups)
    end

    [boys, girls]
  end

  protected

  def age_range(groups, detail, ages)
    range = ages.to_ranges
    groups[range] = [] if groups[range].nil?
    groups[range] << detail
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
