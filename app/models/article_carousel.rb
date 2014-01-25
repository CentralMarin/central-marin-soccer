
class ArticleCarousel  < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  validates :article_id,    :presence => true
  validates :carousel_order,         :presence => true,
                            :uniqueness=>true

  belongs_to :article

  def admin_permalink
    article_carousel_admin_articles_path
  end


end
