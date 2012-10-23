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
  before(:each) do
    @attr = { :name => "Example Coach", :email => "coach@example.com", :bio => "This is a example bio."}
  end

  it "should create a new instance given valid attributes" do
    Coach.create!(@attr)
  end

  it "should require a name" do
    no_name_coach = Coach.new(@attr.merge(:name => ""))
    no_name_coach.should_not be_valid
  end

  it "should require an email address" do
    no_email_coach = Coach.new(@attr.merge(:email => ""))
    no_email_coach.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_coach = Coach.new(@attr.merge(:name => long_name))
    long_name_coach.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_coach = Coach.new(@attr.merge(:email => address))
      valid_email_coach.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      valid_email_coach = Coach.new(@attr.merge(:email => address))
      valid_email_coach.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    Coach.create!(@attr)
    coach_with_duplicate_email = Coach.new(@attr)
    coach_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    Coach.create!(@attr.merge(:email => upcased_email))
    coach_with_duplicate_email = Coach.new(@attr)
    coach_with_duplicate_email.should_not be_valid
  end
end

