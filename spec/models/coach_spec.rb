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

  it "creates a new instance given valid attributes" do
    Coach.create!(@attr)
  end

  it "requires a name" do
    no_name_coach = Coach.new(@attr.merge(:name => ""))
    no_name_coach.should_not be_valid
  end

  it "requires an email address" do
    no_email_coach = Coach.new(@attr.merge(:email => ""))
    no_email_coach.should_not be_valid
  end

  it "rejects names that are too long" do
    long_name = "a" * 51
    long_name_coach = Coach.new(@attr.merge(:name => long_name))
    long_name_coach.should_not be_valid
  end

  it "accepts valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_coach = Coach.new(@attr.merge(:email => address))
      valid_email_coach.should be_valid
    end
  end

  it "rejects invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      valid_email_coach = Coach.new(@attr.merge(:email => address))
      valid_email_coach.should_not be_valid
    end
  end

  it "rejects duplicate email addresses" do
    Coach.create!(@attr)
    coach_with_duplicate_email = Coach.new(@attr)
    coach_with_duplicate_email.should_not be_valid
  end

  it "rejects email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    Coach.create!(@attr.merge(:email => upcased_email))
    coach_with_duplicate_email = Coach.new(@attr)
    coach_with_duplicate_email.should_not be_valid
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

