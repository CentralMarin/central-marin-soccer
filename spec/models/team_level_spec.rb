# == Schema Information
#
# Table name: team_levels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe TeamLevel do
  before(:each) do
    @attr = { :name => "Sample level"}
  end

  it "should create a team_level given valid attributes" do
    TeamLevel.create!(@attr)
  end

  context "translations" do
    before(:each) do
      I18n.locale = :en
      @team_level = TeamLevel.create name: "Sample name"
      I18n.locale = :es
      @team_level.update_attributes name: "Muestra nombre"
    end

    it "should read the correct translation" do
      @team_level = TeamLevel.last

      I18n.locale = :en
      @team_level.name.should == "Sample name"

      I18n.locale = :es
      @team_level.name.should == "Muestra nombre"
    end
  end
end
