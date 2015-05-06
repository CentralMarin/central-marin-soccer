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

  active_admin_translates :title, :body

  has_many :article_carousels, :dependent => :destroy

  ARTICLE_CATEGORY = [:club, :team, :coach, :referee, :tournament]

  validates :title,         :presence => true,
                           :length => { :maximum => 255 }
  validates :body,        :presence => true
  validates :category_id, :presence => true

  def page_title
    self.to_s
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

  def category?(sym)
    ARTICLE_CATEGORY.index(sym) == self[:category_id]
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

  # Include the image processing module
  include ImageProcessing

  # Define Image dimensions
  IMAGE_WIDTH = 560
  IMAGE_HEIGHT = 420

end
