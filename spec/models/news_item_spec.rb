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
  before(:each) do
    @attr = { :title => "Sample Title", :body => "<h1><b>Header<b></h1><p>Content</p>", :author => "Sample Author", :carousel => false, :category_id => NewsItem::NEWS_CATEGORY[0]}
  end

  it "should create a news item given valid attributes" do
    NewsItem.create!(@attr)
  end

  it "should require a title" do
    no_title_news = NewsItem.new(@attr.merge(:title => ""))
    no_title_news.should_not be_valid
  end

  it "should reject titles that are too long" do
    long_title = "a" * 256
    long_title_news = NewsItem.new(@attr.merge(:title => long_title))
    long_title_news.should_not be_valid

  end

  it "should require body" do
    no_body_news = NewsItem.new(@attr.merge(:body => ""))
    no_body_news.should_not be_valid
  end

  context "translations" do
    before(:each) do
      puts "creating translations"
      I18n.locale = :en
      @news_item = NewsItem.create title: "Sample Title", body: "HTML Body", author: "Sample Author", carousel: false, category_id: NewsItem::NEWS_CATEGORY[0]
      I18n.locale = :es
      @news_item.update_attributes title: "Muestra Título", body: "HTML Cuerpo"

      puts "done"
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
