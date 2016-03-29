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

end
