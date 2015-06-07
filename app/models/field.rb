# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  club       :string(255)
#  rain_line  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state_id   :integer
#  lat        :decimal(15, 10)
#  lng        :decimal(15, 10)
#  address    :string(255)
#

require "net/http"
require "uri"
require "json"

class Field < Location
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  validates :name,  :presence => true
  validates :rain_line, :presence => true
  validates :address, :presence => true
  validates :status, :presence => true

  has_many :event_details

  default_scope { order('name asc') }

  def admin_permalink
    admin_field_path(self)
  end

  def status_name
    Field.statuses[status]
  end

  def self.statuses
    [I18n.t('field.status.open'), I18n.t('field.status.closed'), I18n.t('field.status.call')]
  end

  def map_url
    "http://maps.google.com/maps?q=#{lat},#{lng}&iwloc=A"
  end

  def as_json(options = {})
    { :id => self.id, :name => self.name, :club => self.club, :rain_line => self.rain_line, :address => self.address, :lat => self.lat, :lng => self.lng, :status => self.status, :status_name => self.status_name   }
  end

  def to_s
    name
  end


end
