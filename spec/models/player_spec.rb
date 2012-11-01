# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Player do

  it "has a valid factory" do
    FactoryGirl.create(:player)
  end

  it "requires a first name" do
    FactoryGirl.build(:player, first_name: nil).should_not be_valid
  end

  it "requires a last name" do
    FactoryGirl.build(:player, last_name: nil).should_not be_valid
  end

  it "requires at least one parent" do
    FactoryGirl.build(:player, parents: []).should_not be_valid
  end
end
