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

require 'spec_helper'

describe Field do
  it "has a valid factory" do
    FactoryGirl.create(:field)
  end

  it "requires a name" do
    FactoryGirl.build(:field, name: nil).should_not be_valid
  end

  it "requires a club" do
    FactoryGirl.build(:field, club: nil).should_not be_valid
  end

  it "requires a rain line" do
    FactoryGirl.build(:field, rain_line: nil).should_not be_valid
  end

  it "requires an address" do
    FactoryGirl.build(:field, address: nil).should_not be_valid
  end

  it "requires a state id" do
    FactoryGirl.build(:field, state_id: nil).should_not be_valid
  end

  context "instance methods" do
    it "state_id should convert to and from a symbol" do
      field = FactoryGirl.create(:field)
      state_id = field.state_id
      Field.state_id(field.state).should == state_id
    end

    it "map_url should properly return a google maps url" do
      FactoryGirl.create(:field).map_url.starts_with?("http://maps.google.com").should == true
    end

    it "object as a string" do
      field = FactoryGirl.create(:field)
      field.to_s.should == field.name
    end

    it "json representation of the object should include id, name, club, rain_line, address, lat, lng, and state" do
      field = FactoryGirl.create(:field)
      json = field.as_json
      json[:id].should == field.id
      json[:name].should == field.name
      json[:club].should == field.club
      json[:rain_line].should == field.rain_line
      json[:address].should == field.address
      json[:lat].should == field.lat
      json[:lng].should == field.lng
      json[:state].should == field.state
    end
  end

  context "translations" do
    it "field status should change depending on locale" do
      I18n.locale = :en
      english = Field.states
      I18n.locale = :es
      Field.states.should_not == english
    end
  end
end
