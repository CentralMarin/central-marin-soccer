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

require 'rails_helper'

describe Coach do
  it "has a valid factory" do
    expect(FactoryGirl.create(:coach)).to be_valid
  end

  it "requires a name" do
    expect(FactoryGirl.build(:coach, name: nil)).to_not be_valid
  end

  it "requires an email address" do
    expect(FactoryGirl.build(:coach, email: nil)).to_not be_valid
  end

  it "rejects names that are too long" do
    long_name = "a" * 51
    expect(FactoryGirl.build(:coach, name: long_name)).to_not be_valid
  end

  it "rejects invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      expect(FactoryGirl.build(:coach, email: address)).to_not be_valid
    end
  end

  it "rejects duplicate email addresses" do
    coach = FactoryGirl.create(:coach)
    expect(FactoryGirl.build(:coach, email: coach.email)).to_not be_valid
  end

  it "rejects email addresses identical up to case" do
    coach = FactoryGirl.create(:coach)
    expect(FactoryGirl.build(:coach, email: coach.email.upcase)).to_not be_valid
  end

  context "instance methods" do
    it "returns a relative url for an coaches image" do
      expect(FactoryGirl.create(:coach).image_url).to be_kind_of(String)
    end

    it "returns a jpeg" do
      expect(FactoryGirl.create(:coach).image_url.ends_with?('.jpeg')).to eq(true)
    end

    it "returns name as string object representation" do
      coach = FactoryGirl.create(:coach)
      expect(coach.to_s).to eq(coach.name)
    end

    it "returns json containing name, bio, and teams" do
      coach = FactoryGirl.create(:coach)
      json = coach.as_json
      expect(json[:name]).to eq(coach.name)
      expect(json[:bio]).to eq(coach.bio)
      expect(json[:teams]).to eq(coach.teams)
    end

  end

  C_NAME_ENGLISH = 'Sample Name'
  C_NAME_SPANISH = 'Dónde está el baño'
  C_EMAIL = 'test@test.com'
  C_BIO = 'Sample bio'

  context "translations" do
    before(:each) do
      I18n.locale = :en
      @coach = Coach.create name: C_NAME_ENGLISH, email: C_EMAIL, bio: C_BIO
      I18n.locale = :es
      @coach.update_attributes bio: C_NAME_SPANISH
    end

    it "reads the correct translation" do
      @coach = Coach.last

      I18n.locale = :en
      expect(@coach.name).to eq(C_NAME_ENGLISH)
      expect(@coach.email).to eq(C_EMAIL)
      expect(@coach.bio).to eq(C_BIO)

      I18n.locale = :es
      expect(@coach.bio).to eq(C_NAME_SPANISH)
    end
  end
end

