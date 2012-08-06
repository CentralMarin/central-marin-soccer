class NewsItemTranslation < ActiveRecord::Base
  belongs_to :news_item
  validates_uniqueness_of :locale, :scope => :news_id
end