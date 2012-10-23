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
  before(:each) do
    @coach = Factory(:coach)
    @team_level = Factory(:team_level)


    @attr = { :age => 9, :gender => Team::GENDERS[0], :name => "Test Team", :coach => @coach, :team_level => @team_level}
  end

  it "should create a new instance given valid attributes" do
    Team.create!(@attr)
  end

  it "should require an age" do
    no_age_team = Team.new(@attr.merge(:age => nil))
    no_age_team.should_not be_valid
  end

  it "should require an age 8 or older" do
    invalid_age_team = Team.new(@attr.merge(:age => 7))
    invalid_age_team.should_not be_valid
  end

  it "should require an age 18 or younger" do
    invalid_age_team = Team.new(@attr.merge(:age => 19))
    invalid_age_team.should_not be_valid
  end

  it "should require a gender" do
    no_gender_team = Team.new(@attr.merge(:gender => nil))
    no_gender_team.should_not be_valid
  end

  it "should require a coach" do
    no_coach_team = Team.new(@attr.merge(:coach => nil))
    no_coach_team.should_not be_valid
  end

  it "should require a team_level" do
    no_team_level_team = Team.new(@attr.merge(:team_level => nil))
    no_team_level_team.should_not be_valid
  end

  describe "associations" do
    before(:each) do
      @team = Team.create!(@attr)
    end

    describe "coach" do

      it "should have a coach attribute" do
        @team.should respond_to(:coach)
      end

      it "should have the right associated coach" do
        @team.coach_id.should == @coach.id
        @team.coach.should == @coach
      end
    end

    describe "gender" do

      it "should have a gender attribute" do
        @team.should respond_to(:gender)
      end

      it "should have the right associated gender" do
        @team.gender.should == Team::GENDERS[0]
      end
    end

    describe "team_level" do

      it "should have a team_level attribute" do
        @team.should respond_to(:team_level)
      end

      it "should have the right associated team_level" do
        @team.team_level_id.should == @team_level.id
        @team.team_level.should == @team_level
      end
    end

  end

  describe "links" do
    #it "should have a links attribute" do
    #  @team.should respond_to(:links)
    #end
  end

end


