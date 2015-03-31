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

  TRYOUT_YEAR = 2015

  def self.tryouts(gender = nil, month = nil, year = nil)
    events(:tryout, :tryout, gender, month, year)
  end

  def self.tryout_related_events(gender = nil, month = nil, year = nil)
    events(:upcoming_tryout, :tryout_complete, gender, month, year)
  end

  def self.united_related_events(gender = nil, month = nil, year = nil)
    events(:united_upcoming_tryout, :united_upcoming_tryout, gender, month, year)
  end

  protected

  def self.events(start_type, end_type, gender = nil, month = nil, year = nil)
    event_types = self.types.select { |k,v| v >= self.types[start_type] && v <= self.types[end_type]}.values

    query = Event.joins(:event_groups).where(:type => event_types).where.not(status: self.statuses[:hide])

    if gender.present? and month.present? and year.present?
      age_level = TRYOUT_YEAR - year + 1;
      if month > 7
        age_level = age_level - 1
      end

      age_group = "U#{age_level}_#{gender}"

      query = query.where('groups & ? > 0', EventGroup.bitmasks[:groups][age_group])
    end

    query
  end

  def self.events_for_age(start_type, end_type, gender, month, year)
    event_types = self.types.select { |k,v| v >= self.types[start_type] && v <= self.types[end_type]}.values

    Event.where(:type => event_types).where.not(status: self.statuses[:hide])
  end

  def self.find_age_group(events, gender, month, year)

    age_level = TRYOUT_YEAR - year + 1;
    if month > 7
      age_level = age_level - 1
    end

    age_group = "U#{age_level}_#{gender}".to_sym

    events.each do |event|
      event.event_groups = event.event_groups.select {|event_group| event_group.groups?(age_group) }
    end

    events

  end

end
# EventGroup.where("groups & ? > 0", 1).count
