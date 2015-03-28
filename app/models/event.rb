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

  def self.tryouts
    events(:tryout, :tryout)
  end

  def self.tryout_related_events
    events(:upcoming_tryout, :tryout_complete)
  end

  def self.united_related_events
    events(:united_upcoming_tryout, :united_upcoming_tryout)
  end

  protected

  def self.events(start_type, end_type)
    event_types = self.types.select { |k,v| v >= self.types[start_type] && v <= self.types[end_type]}.values

    Event.where(:type => event_types).where.not(status: self.statuses[:hide])
  end
end
