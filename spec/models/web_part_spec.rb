require 'spec_helper'

describe WebPart do
  it "has a valid factory" do
    FactoryGirl.create(:web_part).should be_valid
  end

  it "requires a name" do
    FactoryGirl.build(:web_part, name: nil).should_not be_valid
  end

  it "requires html" do
    FactoryGirl.build(:web_part, html: nil).should_not be_valid
  end

  it "rejects duplicate names" do
    web_part = FactoryGirl.create(:web_part)
    FactoryGirl.build(:web_part, name: web_part.name).should_not be_valid
  end

  context "translations" do
    it "reads the correct translation" do

      name = 'Sample name'
      html = ['Sample html', 'Muestra html']

      I18n.locale = :en
      web_part = WebPart.create name: name, html: html[0]
      I18n.locale = :es
      web_part.update_attributes html: html[1]

      web_part_db = WebPart.last

      I18n.locale = :en
      web_part_db.name.should == name
      web_part_db.html.should == html[0]

      I18n.locale = :es
      web_part_db.name.should == name
      web_part_db.html.should == html[1]
    end
  end

end
