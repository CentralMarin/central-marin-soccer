# == Schema Information
#
# Table name: teams
#
#  id            :integer          not null, primary key
#  age           :integer
#  gender        :string(255)
#  name          :string(255)
#  coach_id      :integer
#  team_level_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Team do
  it "has a valid factory" do
    FactoryGirl.create(:team)
  end

  it "requires a year" do
    FactoryGirl.build(:team, year: nil).should_not be_valid
  end

  #it "requires an age 8 or older" do
  #  FactoryGirl.build(:team, year: 7).should_not be_valid
  #  FactoryGirl.build(:team, age: 8).should be_valid
  #end
  #
  #it "requires an age 18 or younger" do
  #  FactoryGirl.build(:team, age: 19).should_not be_valid
  #  FactoryGirl.build(:team, age:18).should be_valid
  #end
  #
  #it "requires a gender" do
  #  FactoryGirl.build(:team, gender_id: nil).should_not be_valid
  #end
  #
  it "requires a coach" do
    FactoryGirl.build(:team, coach: nil).should_not be_valid
  end

  it "requires a team_level" do
    FactoryGirl.build(:team, team_level: nil).should_not be_valid
  end

  it "requires a team manager name" do
    FactoryGirl.build(:team, manager_name: nil).should_not be_valid
  end

  it "requires a valid team manager email address" do
    FactoryGirl.build(:team, manager_email: nil).should_not be_valid
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]

    addresses.each do |address|
      FactoryGirl.build(:team, manager_email: address).should_not be_valid
    end

  end

  it "requires a valid team manager phone number" do
    FactoryGirl.build(:team, manager_phone: nil).should_not be_valid

    phone_numbers = %w[123-123-1234 (123)123-1234 9999999999 999999-9999 999-7890987]
    invalid_phone_numbers = %w[123-1234 (AAA)123-1234 123-123 1 132-AAAA (123)123-AAAA (132)AAA-BBBB]

    phone_numbers.each do |phone|
      FactoryGirl.build(:team, manager_phone: phone).should be_valid
    end

    invalid_phone_numbers.each do |phone|
      FactoryGirl.build(:team, manager_phone: phone).should_not be_valid
    end
  end

  #describe "associations" do
  #  before(:each) do
  #    @team = Team.create!(@attr)
  #  end
  #
  #  describe "coach" do
  #
  #    it "should have a coach attribute" do
  #      @team.should respond_to(:coach)
  #    end
  #
  #    it "should have the right associated coach" do
  #      @team.coach_id.should == @coach.id
  #      @team.coach.should == @coach
  #    end
  #  end
  #
  #  describe "gender" do
  #
  #    it "should have a gender attribute" do
  #      @team.should respond_to(:gender)
  #    end
  #
  #    it "should have the right associated gender" do
  #      @team.gender.should == Team::GENDERS[0]
  #    end
  #  end
  #
  #  describe "team_level" do
  #
  #    it "should have a team_level attribute" do
  #      @team.should respond_to(:team_level)
  #    end
  #
  #    it "should have the right associated team_level" do
  #      @team.team_level_id.should == @team_level.id
  #      @team.team_level.should == @team_level
  #    end
  #  end
  #
  #end
  #
  describe "links" do
    #it "should have a links attribute" do
    #  @team.should respond_to(:links)
    #end
  end

end


