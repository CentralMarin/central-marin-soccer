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

class NewsItem < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  translates :title, :body, versioning: true
  accepts_nested_attributes_for :translations, :allow_destroy => true
  has_many :news_item_translations

  NEWS_CATEGORY = [:club, :team, :coach, :referee, :tournament]

  attr_accessible :title, :body, :image, :author, :category_id, :subcategory_id, :carousel, :translations_attributes
  mount_uploader :image, ImageUploader

  validates :title,         :presence => true,
                           :length => { :maximum => 255 }
  validates :body,        :presence => true
  validates :category_id, :presence => true

  def page_title
    self.to_s
  end

  def admin_permalink
    admin_news_item_path(self)
  end

  def to_s
    title
  end

  def category=(sym)
    self[:category_id]=NEWS_CATEGORY.index(sym)
  end

  def category
    NEWS_CATEGORY[read_attribute(:category_id)]
  end

  def self.category_id(sym)
    NEWS_CATEGORY.index(sym)
  end

  def has_translation
    translation = translations.find_by_locale('es')
    translation && translation.title != ''
  end

  def to_param
    "#{id} #{to_s}".parameterize
  end

  class Translation
    include Rails.application.routes.url_helpers # needed for _path helpers to work in models

    attr_accessible :title, :body

    def admin_permalink
      admin_news_item_path(self)
    end

    def to_s
      news_item = NewsItem.find(self['news_item_id'])
      news_item.title
    end

  end

end
