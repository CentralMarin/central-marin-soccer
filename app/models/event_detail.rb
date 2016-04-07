class EventDetail < ActiveRecord::Base
  belongs_to :event
  belongs_to :location

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
      result += v.length > 3 ? v[0].to_s + '-' + v[-1].to_s : v.join(', ')
    end

    result
  end

  protected

  # TODO: Add birthyear

end
