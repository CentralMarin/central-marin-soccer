#encoding: utf-8

# == Schema Information
#
# Table name: news_items
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  body           :text
#  author         :string(255)
#  carousel       :boolean
#  category_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image          :string(255)
#  subcategory_id :integer
#

require 'spec_helper'

describe NewsItem do
  it "has a valid factory" do
    FactoryGirl.create(:news_item)
  end

  it "requires a title" do
    FactoryGirl.build(:news_item, title: nil).should_not be_valid
  end

  it "rejects titles that are too long" do
    long_title = "a" * 256
    FactoryGirl.build(:news_item, title: long_title).should_not be_valid
  end

  it "requires body" do
    FactoryGirl.build(:news_item, body: nil).should_not be_valid
  end

  it "saves settings properly" do

    news_item = FactoryGirl.create(:news_item)
    news_item.save

    db_news_item = NewsItem.last
    db_news_item.title.should == news_item.title
    db_news_item.body.should == news_item.body
    db_news_item.author.should == news_item.author
    db_news_item.carousel.should == news_item.carousel
    db_news_item.category_id.should == news_item.category_id
    db_news_item.subcategory_id.should == news_item.subcategory_id
  end

  context "instance methods" do

  end

  context "translations" do
    before(:each) do
      I18n.locale = :en
      @news_item = NewsItem.create title: "Sample Title", body: "HTML Body", author: "Sample Author", carousel: false, category_id: NewsItem::NEWS_CATEGORY[0]
      I18n.locale = :es
      @news_item.update_attributes title: "Muestra Título", body: "HTML Cuerpo"
    end

    it "should read the correct translation" do
      @news_item = NewsItem.last

      I18n.locale = :en
      @news_item.title.should == "Sample Title"
      @news_item.body.should == "HTML Body"

      I18n.locale = :es
      @news_item.title.should == "Muestra Título"
      @news_item.body.should == "HTML Cuerpo"
    end
  end
end
