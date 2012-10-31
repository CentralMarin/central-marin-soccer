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

  it "should require a state id" do
    FactoryGirl.build(:field, state_id: nil).should_not be_valid
  end
end
