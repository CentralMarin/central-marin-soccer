# == Schema Information
#
# Table name: team_levels
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe TeamLevel do
  before(:each) do
    @attr = { :name => "Sample level"}
  end

  it "should create a team_level given valid attributes" do
    TeamLevel.create!(@attr)
  end
end
