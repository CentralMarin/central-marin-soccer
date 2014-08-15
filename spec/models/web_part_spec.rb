require 'rails_helper'

describe WebPart do
  it "has a valid factory" do
    expect(FactoryGirl.create(:web_part)).to be_valid
  end

  it "requires a name" do
    expect(FactoryGirl.build(:web_part, name: nil)).to_not be_valid
  end

  it "requires html" do
    expect(FactoryGirl.build(:web_part, html: nil)).to_not be_valid
  end

  it "rejects duplicate names" do
    web_part = FactoryGirl.create(:web_part)
    expect(FactoryGirl.build(:web_part, name: web_part.name)).to_not be_valid
  end

  context "translations" do
    it "reads the correct translation" do

      name = 'Sample name'
      html = ['Sample html', 'Dónde está el baño']

      I18n.locale = :en
      web_part = WebPart.create name: name, html: html[0]
      I18n.locale = :es
      web_part.update_attributes html: html[1]

      web_part_db = WebPart.last

      I18n.locale = :en
      expect(web_part_db.name).to eq(name)
      expect(web_part_db.html).to eq(html[0])

      I18n.locale = :es
      expect(web_part_db.name).to eq(name)
      expect(web_part_db.html).to eq(html[1])
    end
  end

end
