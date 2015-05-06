require 'rails_helper'

describe ArticleCarousel do
  it "has a valid factory" do
    expect(FactoryGirl.create(:article)).to be_valid
  end

  it "requires a carousel order" do
    expect(FactoryGirl.build(:article_carousel, carousel_order: nil)).to_not be_valid
  end

  it "has a unique carousel order" do
    article_carousel = FactoryGirl.create(:article_carousel)
    expect(FactoryGirl.build(:article_carousel, carousel_order: article_carousel.carousel_order)).to_not be_valid
  end

  it "allows the same article to be in the carousel multiple times" do
    article_carousel = FactoryGirl.create(:article_carousel)
    ac = FactoryGirl.build(:article_carousel, article_id: article_carousel.article_id, carousel_order: article_carousel.carousel_order + 1)
    expect(ac.save).to eq(true)
    carousels = ArticleCarousel.all
    expect(carousels.count).to eq(2)
  end
end