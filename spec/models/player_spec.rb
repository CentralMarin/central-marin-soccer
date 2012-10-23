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
  before(:each) do
    @parent_one = Factory(:parent_one)
    @parent_two = Factory(:parent_two)

    @attr = { :first_name => 'Katie', :last_name => 'Smith', :parents => [@parent_one, @parent_two]}
  end

  it "should create a new instance given valid attributes" do
    Player.create!(@attr)
  end

  it "should require a first name" do
    no_first_name_player = Player.new(@attr.merge(:first_name => ""))
    no_first_name_player.should_not be_valid
  end

  it "should require a last name" do
    no_last_name_player = Player.new(@attr.merge(:last_name => ""))
    no_last_name_player.should_not be_valid
  end

  it "should require at least one parent" do
    no_parent_player = Player.new(@attr.merge(:parents => []))
    no_parent_player.should_not be_valid
  end

  describe "parent associations" do

    it "should have the right associated parents" do
      player = Player.new(@attr)
      player.parents[0].id.should == @parent_one.id
      player.parents[0].should == @parent_one
      player.parents[1].id.should == @parent_two.id
      player.parents[1].should == @parent_two
    end
  end

end
