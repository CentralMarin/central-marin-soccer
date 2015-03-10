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

class Field < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  validates :name,  :presence => true
  validates :club, :presence => true
  validates :rain_line, :presence => true
  validates :address, :presence => true
  validates :status, :presence => true

  before_save :set_latlng

  has_many :tryouts
  has_many :event_details

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

  protected

  def set_latlng

    # geocode the address
    uri = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{CGI.escape(address)},+CA&sensor=false")

    # Shortcut
    response = Net::HTTP.get_response(uri)
    if (response.code != '200')
      errors.add(:base, "Unable to convert address to latitude and longitude - HTTP response #{response.code}" )
      return false
    end

    json = JSON.parse(response.body)
    if (json['status'] != 'OK')
      errors.add(:base, "Unable to convert address to latitude and longitude - JSON status #{json['status']}")
      return false
    end

    location = json['results'][0]['geometry']['location']

    self.lat = location['lat']
    self.lng = location['lng']
  end

end
