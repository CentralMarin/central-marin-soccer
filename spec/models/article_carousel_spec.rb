require 'spec_helper'

describe ArticleCarousel do
  it "has a valid factory" do
    FactoryGirl.create(:article)
  end

  it "requires a carousel order" do
    FactoryGirl.build(:article_carousel, carousel_order: nil).should_not be_valid
  end

  it "has a unique carousel order" do
    article_carousel = FactoryGirl.create(:article_carousel)
    FactoryGirl.build(:article_carousel, carousel_order: article_carousel.carousel_order).should_not be_valid
  end

  it "allows the same article to be in the carousel multiple times" do
    article_carousel = FactoryGirl.create(:article_carousel)
    ac = FactoryGirl.build(:article_carousel, article_id: article_carousel.article_id, carousel_order: article_carousel.carousel_order + 1)
    ac.save.should == true
    carousels = ArticleCarousel.all
    carousels.count.should == 2
  end
end