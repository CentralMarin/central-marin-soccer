#encoding: utf-8

# == Schema Information
#
# Table name: articles
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

describe Article do
  it "has a valid factory" do
    FactoryGirl.create(:article)
  end

  it "requires a title" do
    FactoryGirl.build(:article, title: nil).should_not be_valid
  end

  it "rejects titles that are too long" do
    long_title = "a" * 256
    FactoryGirl.build(:article, title: long_title).should_not be_valid
  end

  it "requires body" do
    FactoryGirl.build(:article, body: nil).should_not be_valid
  end

  it "saves settings properly" do

    article = FactoryGirl.create(:article)
    article.save

    db_article = Article.last
    db_article.title.should == article.title
    db_article.body.should == article.body
    db_article.author.should == article.author
    db_article.carousel.should == article.carousel
    db_article.category_id.should == article.category_id
    db_article.subcategory_id.should == article.subcategory_id
  end

  context "instance methods" do

  end

  context "translations" do
    before(:each) do
      I18n.locale = :en
      @article = Article.create title: "Sample Title", body: "HTML Body", author: "Sample Author", carousel: false, category_id: Article::ARTICLE_CATEGORY[0]
      I18n.locale = :es
      @article.update_attributes title: "Muestra Título", body: "HTML Cuerpo"
    end

    it "should read the correct translation" do
      @article = Article.last

      I18n.locale = :en
      @article.title.should == "Sample Title"
      @article.body.should == "HTML Body"

      I18n.locale = :es
      @article.title.should == "Muestra Título"
      @article.body.should == "HTML Cuerpo"
    end
  end
end
