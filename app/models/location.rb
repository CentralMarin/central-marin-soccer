class Location < ActiveRecord::Base

  before_save :set_latlng

  def map_url
    "http://maps.google.com/maps?q=#{lat},#{lng}&iwloc=A"
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