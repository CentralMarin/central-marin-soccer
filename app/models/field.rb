# == Schema Information
#
# Table name: fields
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  club       :string(255)
#  rain_line  :string(255)
#  map_url    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "net/http"
require "uri"
require "json"

class Field < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  has_paper_trail

  attr_accessible :name, :club, :rain_line, :address, :state_id

  validates :name,  :presence => true
  validates :club, :presence => true
  validates :rain_line, :presence => true
  validates :address, :presence => true
  validates :state_id, :presence => true

  before_save :set_latlng

  def admin_permalink
    admin_field_path(self)
  end

  def state(sym)
    self[:state_id]=STATES.index(sym)
  end

  def state
    if I18n.locale == :es
      SPANISH_STATES[read_attribute(:state_id)]
    else
      STATES[read_attribute(:state_id)]
    end
  end

  def self.state_id(sym)
    STATES.index(sym)
  end

  def self.states
    if I18n.locale == :es
      SPANISH_STATES
    else
      STATES
    end
  end

  def map_url
    "http://maps.google.com/maps?q=#{lat},#{lng}&iwloc=A"
  end

  def as_json(options = {})
    { :id => self.id, :name => self.name, :club => self.club, :rain_line => self.rain_line, :address => self.address, :lat => self.lat, :lng => self.lng, :state => self.state }
  end

  def to_s
    name
  end

  protected

  STATES = [:open, :closed, :call]
  SPANISH_STATES = ['abrir', 'cerrado', 'llamar']

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
