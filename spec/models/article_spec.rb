#encoding: utf-8

# == Schema Information
#
# Table name: articles
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  body           :text
#  author         :string(255)
#  category_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  image          :string(255)
#  subcategory_id :integer
#

require 'rails_helper'

describe Article do
  it "has a valid factory" do
    expect(FactoryGirl.create(:article)).to be_valid
  end

  it "requires a title" do
    expect(FactoryGirl.build(:article, title: nil)).to_not be_valid
  end

  it "rejects titles that are too long" do
    long_title = "a" * 256
    expect(FactoryGirl.build(:article, title: long_title)).to_not be_valid
  end

  it "requires body" do
    expect(FactoryGirl.build(:article, body: nil)).to_not be_valid
  end

  it "saves settings properly" do

    article = FactoryGirl.create(:article)
    article.save

    db_article = Article.last
    expect(db_article.title).to eq(article.title)
    expect(db_article.body).to eq(article.body)
    expect(db_article.author).to eq(article.author)
    expect(db_article.category_id).to eq(article.category_id)
    expect(db_article.team_id).to eq(article.team_id)
    expect(db_article.coach_id).to eq(article.coach_id)
  end

  TITLE_ENGLISH = 'Sample Title'
  TITLE_SPANISH = 'Dónde está el baño'
  BODY_ENGLISH = '<div class="grid_10 box"><b>Body &nbsp;</b></div>'
  BODY_SPANISH = '<div class="grid_10 box"><b>Dónde está el baño &nbsp;</b></div>'

  context "translations" do
    before(:each) do
      I18n.locale = :en
      @article = Article.create title: TITLE_ENGLISH, body: BODY_ENGLISH, author: "Sample Author", category_id: Article.category_id(Article::ARTICLE_CATEGORY[0])
      I18n.locale = :es
      @article.update_attributes title: TITLE_SPANISH, body: BODY_SPANISH
    end

    it "should read the correct translation" do
      @article = Article.last

      I18n.locale = :en
      expect(@article.title).to eq(TITLE_ENGLISH)
      expect(@article.body).to eq(BODY_ENGLISH)

      I18n.locale = :es
      expect(@article.title).to eq(TITLE_SPANISH)
      expect(@article.body).to eq(BODY_SPANISH)
    end
  end
end
