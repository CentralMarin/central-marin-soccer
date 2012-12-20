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

  translates :title, :body, versioning: true, fallbacks_for_empty_translations: true
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

  # TODO: Build bread crumbs based on article category and subcategory
  #def correct_article_path
  #  # TODO: Build the appropriate URL based on category_id and subcategory_id
  #  # Selecting Coach and no team shows the article for all of the coaches' teams
  #  # Selecting Team and no team shows the article on all team pages
  #  case category
  #    when :club
  #    when :team
  #      if subcategory_id.nil?
  #        teams_path
  #      else
  #        team_path(subcategory_id)
  #      end
  #    when :coach
  #      if subcategory_id.nil?
  #        coaches_path
  #      else
  #        coach_path
  #      end
  #    when :referee
  #    when :tournament
  #
  #    else
  #      '/'
  #  end
  #end

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
