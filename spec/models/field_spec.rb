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

require 'rails_helper'

describe Field do
  it "has a valid factory" do
    expect(FactoryGirl.create(:field)).to be_valid
  end

  it "requires a name" do
    expect(FactoryGirl.build(:field, name: nil)).to_not be_valid
  end

  it "requires a club" do
    expect(FactoryGirl.build(:field, club: nil)).to_not be_valid
  end

  it "requires a rain line" do
    expect(FactoryGirl.build(:field, rain_line: nil)).to_not be_valid
  end

  it "requires an address" do
    expect(FactoryGirl.build(:field, address: nil)).to_not be_valid
  end

  it "requires a status" do
    expect(FactoryGirl.build(:field, status: nil)).to_not be_valid
  end

  context "instance methods" do
    it "map_url should properly return a google maps url" do
      expect(FactoryGirl.create(:field).map_url.starts_with?("http://maps.google.com")).to eq(true)
    end

    it "object as a string" do
      field = FactoryGirl.create(:field)
      expect(field.to_s).to eq(field.name)
    end

    it "json representation of the object should include id, name, club, rain_line, address, lat, lng, and status" do
      field = FactoryGirl.create(:field)
      json = field.as_json
      expect(json[:id]).to eq(field.id)
      expect(json[:name]).to eq(field.name)
      expect(json[:club]).to eq(field.club)
      expect(json[:rain_line]).to eq(field.rain_line)
      expect(json[:address]).to eq(field.address)
      expect(json[:lat]).to eq(field.lat)
      expect(json[:lng]).to eq(field.lng)
      expect(json[:status]).to eq(field.status)
      expect(json[:status_name]).to eq(field.status_name)
    end
  end

  context "translations" do
    it "field status should change depending on locale" do
      I18n.locale = :en
      english = Field.statuses
      I18n.locale = :es
      expect(Field.statuses).to_not eq(english)

      spanish = Field.statuses
      I18n.locale = :en
      expect(Field.statuses).to_not eq(spanish)
    end
  end
end
