
class ArticleCarousel  < ActiveRecord::Base
  attr_accessible :article_id, :carousel_order

  validates :article_id,    :presence => true
  validates :carousel_order,         :presence => true,
                            :uniqueness=>true

  belongs_to :article
end
