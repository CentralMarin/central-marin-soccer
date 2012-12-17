
class ArticleCarousel  < ActiveRecord::Base
  attr_accessible :article_id, :order

  belongs_to :article
end
