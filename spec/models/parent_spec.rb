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

  it "should create a new instance given valid attributes" do
    Parent.create!(@attr)
  end

  it "should require a name" do
    no_name_parent = Parent.new(@attr.merge(:name => ""))
    no_name_parent.should_not be_valid
  end

  it "should require an email" do
    no_email_parent = Parent.new(@attr.merge(:email => ""))
    no_email_parent.should_not be_valid
  end

  it "should require a home_phone" do
    no_home_phone_parent = Parent.new(@attr.merge(:home_phone => ""))
    no_home_phone_parent.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_parent = Parent.new(@attr.merge(:email => address))
      valid_email_parent.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@goo.]
    addresses.each do |address|
      invalid_email_parent = Parent.new(@attr.merge(:email => address))
      invalid_email_parent.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    Parent.create!(@attr)
    parent_with_duplicate_email = Parent.new(@attr)
    parent_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    Parent.create!(@attr.merge(:email => upcased_email))
    parent_with_duplicate_email = Parent.new(@attr)
    parent_with_duplicate_email.should_not be_valid
  end

  it "should accept valid home phone numbers" do
    @phone_numbers.each do |number|
      valid_phone_parent = Parent.new(@attr.merge(:home_phone => number))
      valid_phone_parent.should be_valid
    end
  end

  it "should reject invalid home phone numbers" do
    @invalid_phone_numbers.each do |number|
      invalid_phone_parent = Parent.new(@attr.merge(:home_phone => number))
      invalid_phone_parent.should_not be_valid
    end
  end

  it "should accept valid cell phone numbers" do
    @phone_numbers.each do |number|
      valid_phone_parent = Parent.new(@attr.merge(:cell_phone => number))
      valid_phone_parent.should be_valid
    end
  end

  it "should reject invalid cell phone numbers" do
    @invalid_phone_numbers.each do |number|
      invalid_phone_parent = Parent.new(@attr.merge(:cell_phone => number))
      invalid_phone_parent.should_not be_valid
    end
  end

end
