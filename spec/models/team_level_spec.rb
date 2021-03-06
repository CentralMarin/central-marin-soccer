# == Schema Information
#
# Table name: team_levels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

describe TeamLevel do
  it "has a valid factory" do
    FactoryGirl.create(:team_level)
  end

  TL_NAME_ENGLISH = 'Sample name'
  TL_NAME_SPANISH = 'Muestra nombre'

  context "translations" do
    before(:each) do
      I18n.locale = :en
      team_level = TeamLevel.create name: TL_NAME_ENGLISH
      I18n.locale = :es
      team_level.update_attributes name: TL_NAME_SPANISH
    end

    it "should read the correct translation" do
      team_level = TeamLevel.last

      I18n.locale = :en
      expect(team_level.name).to eq(TL_NAME_ENGLISH)

      I18n.locale = :es
      expect(team_level.name).to eq(TL_NAME_SPANISH)
    end
  end
end
