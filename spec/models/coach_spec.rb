# == Schema Information
#
# Table name: coaches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Coach do
  it "has a valid factory" do
    FactoryGirl.create(:coach).should be_valid
  end

  it "requires a name" do
    FactoryGirl.build(:coach, name: nil).should_not be_valid
  end

  it "requires an email address" do
    FactoryGirl.build(:coach, email: nil).should_not be_valid
  end

  it "rejects names that are too long" do
    long_name = "a" * 51
    FactoryGirl.build(:coach, name: long_name).should_not be_valid
  end

  it "rejects invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      FactoryGirl.build(:coach, email: address).should_not be_valid
    end
  end

  it "rejects duplicate email addresses" do
    coach = FactoryGirl.create(:coach)
    FactoryGirl.build(:coach, email: coach.email).should_not be_valid
  end

  it "rejects email addresses identical up to case" do
    coach = FactoryGirl.create(:coach)
    FactoryGirl.build(:coach, email: coach.email.upcase).should_not be_valid
  end

  context "instance methods" do
    it "returns a relative url for an coaches image" do
      coach = FactoryGirl.create(:coach).image_url.should be_kind_of(String)
    end

    it "returns a jpeg" do
      FactoryGirl.create(:coach).image_url.ends_with?('.jpg').should == true
    end

    it "returns name as string object representation" do
      coach = FactoryGirl.create(:coach)
      coach.to_s.should == coach.name
    end

    it "returns json containing name, bio, and teams" do
      coach = FactoryGirl.create(:coach)
      json = coach.as_json
      json[:name].should == coach.name
      json[:bio].should == coach.bio
      json[:teams].should == coach.teams
    end

  end

  context "translations" do
    before(:each) do
      I18n.locale = :en
      @coach = Coach.create name: "Sample name", email: "test@test.com", bio: "Sample bio"
      I18n.locale = :es
      @coach.update_attributes bio: "Muestra nombre"
    end

    it "reads the correct translation" do
      @coach = Coach.last

      I18n.locale = :en
      @coach.name.should == "Sample name"
      @coach.email.should == "test@test.com"
      @coach.bio.should == "Sample bio"

      I18n.locale = :es
      @coach.bio.should == "Muestra nombre"
    end
  end
end

