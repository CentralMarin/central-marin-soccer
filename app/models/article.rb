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

class Article < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  translates :title, :body, versioning: true
  accepts_nested_attributes_for :translations, :allow_destroy => true
  has_many :article_translations
  has_many :article_carousels

  ARTICLE_CATEGORY = [:club, :team, :coach, :referee, :tournament]

  attr_accessible :title, :body, :image, :author, :category_id, :subcategory_id, :translations_attributes, :published
  mount_uploader :image, ImageUploader

  validates :title,         :presence => true,
                           :length => { :maximum => 255 }
  validates :body,        :presence => true
  validates :category_id, :presence => true

  # Selecting Coach and no team shows the article for all of the coaches' teams
  # Selecting Team and no team shows the article on all team pages

  def page_title
    self.to_s
  end

  def admin_permalink
    admin_article_item_path(self)
  end

  def to_s
    title
  end

  def category=(sym)
    self[:category_id]=ARTICLE_CATEGORY.index(sym)
  end

  def category
    ARTICLE_CATEGORY[read_attribute(:category_id)]
  end

  def self.category_id(sym)
    ARTICLE_CATEGORY.index(sym)
  end

  def has_translation
    translation = translations.find_by_locale('es')
    translation.blank?
  end

  def to_param
    "#{id} #{to_s}".parameterize
  end

  class Translation
    include Rails.application.routes.url_helpers # needed for _path helpers to work in models

    attr_accessible :title, :body

    def admin_permalink
      admin_article_path(self)
    end

    def to_s
      article = Article.find(self['article_id'])
      article.title
    end

  end

end
