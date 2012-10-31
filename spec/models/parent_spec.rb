# == Schema Information
#
# Table name: parents
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  home_phone :string(255)
#  cell_phone :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Parent do

  before(:each) do
    @phone_numbers = %w[123-123-1234 (123)123-1234 9999999999 999999-9999 999-7890987]
    @invalid_phone_numbers = %w[123-1234 (AAA)123-1234 123-123 1 132-AAAA (123)123-AAAA (132)AAA-BBBB]

    @attr = { :name => 'Katie Smith', :email => 'katie@smith.net', :home_phone => '415-123-1234', :cell_phone => '415-098-0987'}
  end

  it "has a valid factory" do
    FactoryGirl.create(:parent)
  end

  it "requires a name" do
    FactoryGirl.build(:parent, name: nil).should_not be_valid
  end

  it "requires an email" do
    FactoryGirl.build(:parent, email: nil).should_not be_valid
  end

  it "requires a home_phone" do
    FactoryGirl.build(:parent, home_phone: nil).should_not be_valid
  end

  it "accepts valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      FactoryGirl.build(:parent, email: address).should be_valid
    end
  end

  it "rejects invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@goo.]
    addresses.each do |address|
      FactoryGirl.build(:parent, email: address).should_not be_valid
    end
  end

  it "rejects duplicate email addresses" do
    parent = FactoryGirl.create(:parent)
    FactoryGirl.build(:parent, email: parent.email).should_not be_valid
  end

  it "rejects email addresses identical up to case" do
    parent = FactoryGirl.create(:parent)
    FactoryGirl.build(:parent, email: parent.email.upcase).should_not be_valid
  end

  it "accepts valid home phone numbers" do
    @phone_numbers.each do |number|
      FactoryGirl.build(:parent, home_phone: number).should be_valid
    end
  end

  it "rejects invalid home phone numbers" do
    @invalid_phone_numbers.each do |number|
      FactoryGirl.build(:parent, home_phone: number).should_not be_valid
    end
  end

  it "accepts valid cell phone numbers" do
    @phone_numbers.each do |number|
      FactoryGirl.build(:parent, cell_phone: number).should be_valid
    end
  end

  it "should reject invalid cell phone numbers" do
    @invalid_phone_numbers.each do |number|
      FactoryGirl.build(:parent, cell_phone: number).should_not be_valid
    end
  end

end
