class Event < ActiveRecord::Base
  enum type: [ :upcoming_tryout, :informational_meeting, :pre_tryout, :tryout, :registration_night, :tryout_complete, :united_upcoming_tryout ]
  enum status: [:show, :show_and_tout, :hide]

  self.inheritance_column = 'does_not_have_one'

  active_admin_translates :heading, :body, :tout

  has_many :event_groups
  accepts_nested_attributes_for :event_groups, :allow_destroy => true

  validates :heading, :presence => true
  validates :body, :presence => true

  default_scope { includes( { event_groups: [:event_details] }) }

  def self.tryouts(gender = nil, month = nil, year = nil)
    events_for_range(:tryout, :tryout, gender, month, year)
  end

  def self.tryout_related_events(gender = nil, month = nil, year = nil)
    events_for_range(:upcoming_tryout, :tryout_complete, gender, month, year)
  end

  def self.united_related_events(gender = nil, month = nil, year = nil)
    events_for_range(:united_upcoming_tryout, :united_upcoming_tryout, gender, month, year)
  end

  def self.touts
    events_for_types(self.types.values, nil, nil, nil).where(status: self.statuses[:show_and_tout])
  end

  protected

  def self.events_for_types(event_types, gender = nil, month = nil, year = nil)
    query = Event.includes(:event_groups).where(:type => event_types).where.not(status: self.statuses[:hide])

    age_group = nil
    if gender.present? and month.present? and year.present?
      age_group = EventGroup.age_group_name(gender, month, year).to_sym

      query = query.joins(:event_groups).where('groups & ? > 0', EventGroup.bitmasks[:groups][age_group])
    end

    return query, age_group
  end

  def self.events_for_range(start_type, end_type, gender = nil, month = nil, year = nil)
    event_types = self.types.select { |k,v| v >= self.types[start_type] && v <= self.types[end_type]}.values

    self.events_for_types(event_types, gender, month, year)
  end

end
