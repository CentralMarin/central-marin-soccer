class EventDetail < ActiveRecord::Base
  belongs_to :event
  belongs_to :location
  has_and_belongs_to_many :player_portals


  AGE_GROUPS = [
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

  BITMASK_METHODS = Proc.new do
    def to_s
      Array(self).join(', ')
    end

    def to_ranges
      return "#{EventDetail::AGE_GROUPS[0].to_s}-#{EventDetail::AGE_GROUPS[-1].to_s}" if self.length == 0

      EventDetail.to_ranges(self)
    end
  end

  bitmask :boys_age_groups, as: AGE_GROUPS, &BITMASK_METHODS
  bitmask :girls_age_groups, as: AGE_GROUPS, &BITMASK_METHODS

  def location_name
    if location_id.nil?
      'TBD'
    else
      location.name
    end
  end

  def self.year_to_age_group(year)
    index = Event.age(year) - 1 - Event::MIN_AGE
    EventDetail::AGE_GROUPS[index]
  end

  def self.age_group_to_year(age_group)
    index = EventDetail::AGE_GROUPS.find_index(age_group)
    Event::TRYOUT_YEAR - index - Event::MIN_AGE
  end

  def self.to_ranges(ages)

    return nil if ages.length == 0

    groups = {}
    ages.each_with_index do |age, index|
      groups[age] = age[1..-1].to_i - index
    end

    groupings = groups.group_by do |k,v|
      v
    end.values.map do |a|
      a.map do |b|
        b[0]
      end
    end

    result = ''
    groupings.each do |v|
      if result != ''
        result += ', '
      end
      result += age_groups_to_string(v)
    end

    result
  end

  def self.age_group_to_string(group)
    "#{group.to_s} (#{age_group_to_year(group)})"
  end

  protected

  def self.age_groups_to_string(groups)
    case groups.length
      when 1
        age_group_to_string(groups[0])
      when 2
        age_group_to_string(groups[0]) + ', ' + age_group_to_string(groups[-1])
      else
        age_group_to_string(groups[0]) + ' - ' + age_group_to_string(groups[-1])
    end
  end

end
