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

require 'spec_helper'

describe Field do
  before(:each) do
    @attr = { :name => "Sample Site", :club => "Sample Club", :rain_line => "234-2344", :address => "335 Franklin School RoadFort Kent, ME 04743", :state_id => 1}
  end

  it "should create a field given valid attributes" do
    Field.create!(@attr)
  end

  it "should require a name" do
    no_name_field = Field.new(@attr.merge(:name => ""))
    no_name_field.should_not be_valid
  end

  it "should require a club" do
    no_club_field = Field.new(@attr.merge(:club => ""))
    no_club_field.should_not be_valid
  end

  it "should require a rain line" do
    no_rain_line_field = Field.new(@attr.merge(:rain_line => ""))
    no_rain_line_field.should_not be_valid
  end

  it "should require an address" do
    no_map_url_field = Field.new(@attr.merge(:address => ""))
    no_map_url_field.should_not be_valid
  end

  it "should require a state id" do
    no_state_id_field = Field.new(@attr.merge(:state_id => nil))
    no_state_id_field.should_not be_valid
  end
end
