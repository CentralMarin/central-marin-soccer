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

require 'rails_helper'

describe Team do
  it "has a valid factory" do
    FactoryGirl.create(:team)
  end

  it "requires a year" do
    expect(FactoryGirl.build(:team, year: nil)).to_not be_valid
  end

  it "instance methods should work on a new team" do
    team = Team.new
    expect(team.gender).to eq(nil)
    expect(team.age).to eq(nil)
    expect(team.two_digit_year).to eq(nil)
    expect(team.page_title).to eq(nil)
  end

  # it "requires an age 8 or older" do
  #   expect(FactoryGirl.build(:team, year: 7)).to_not be_valid
  #   expect(FactoryGirl.build(:team, age: 8)).to be_valid
  # end
  #
  # it "requires an age 18 or younger" do
  #   expect(FactoryGirl.build(:team, age: 19)).to_not be_valid
  #   expect(FactoryGirl.build(:team, age:18)).to be_valid
  # end

  it "requires a gender" do
    expect(FactoryGirl.build(:team, gender_id: nil)).to_not be_valid
  end

  it "requires a coach" do
    expect(FactoryGirl.build(:team, coach: nil)).to_not be_valid
  end

  it "requires a team_level" do
    expect(FactoryGirl.build(:team, team_level: nil)).to_not be_valid
  end

  describe "associations" do
    before(:each) do
      @coach = FactoryGirl.create(:coach)
      @team_level = FactoryGirl.create(:team_level)
      @team = FactoryGirl.create(:team)
      @team.coach = @coach
      @team.team_level = @team_level
    end

    describe "coach" do

       it "should have a coach attribute" do
         expect(@team).to respond_to(:coach)
       end

       it "should have the right associated coach" do
         expect(@team.coach_id).to eq(@coach.id)
         expect(@team.coach).to eq(@coach)
       end
    end

    describe "gender" do

       it "should have a gender attribute" do
         expect(@team).to respond_to(:gender)
       end

       it "should have the right associated gender" do
         @team.gender = I18n.t('team.gender.boys')
         expect(@team.gender).to eq(I18n.t('team.gender.boys'))
       end
    end

    describe "team_level" do

       it "should have a team_level attribute" do
         expect(@team).to respond_to(:team_level)
       end

       it "should have the right associated team_level" do
         expect(@team.team_level_id).to eq(@team_level.id)
         expect(@team.team_level).to eq(@team_level)
       end
    end

  end

  describe "links" do
    #it "should have a links attribute" do
    #  @team.should respond_to(:links)
    #end
  end

end


