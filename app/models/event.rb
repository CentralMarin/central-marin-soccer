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

  def self.tryouts
    events(:tryout, :tryout)
  end

  def self.tryouts_for_age(gender, month, year)
    events = tryouts

    # find the tryouts for the specified gender and birthday
    find_age_group(events, gender, month, year) unless events.nil? or events.count == 0
  end

  def self.tryout_related_events
    events(:upcoming_tryout, :tryout_complete)
  end

  def self.tryout_related_events_for_age(gender, month, year)
    events = tryout_related_events
    find_age_group(events, gender, month, year) unless events.nil? or events.count == 0
  end

  def self.united_related_events
    events(:united_upcoming_tryout, :united_upcoming_tryout)
  end

  protected

  def self.events(start_type, end_type)
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
