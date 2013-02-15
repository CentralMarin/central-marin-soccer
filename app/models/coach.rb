# == Schema Information
#
# Table name: coaches
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  bio        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Coach < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  translates :bio, versioning: true, fallbacks_for_empty_translations: true
  accepts_nested_attributes_for :translations, :allow_destroy => true
  has_many :team_level_translations

  has_many :teams

  attr_accessible :name, :email, :bio, :translations_attributes

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,         :presence => true,
                           :length => { :maximum => 50 }
  validates :email,        :presence => true,
                           :format => { :with => email_regex },
                           :uniqueness => { :case_sensitive => false }

  MISSING_COACH_URL = 'coach/default-coach.jpg'

  @image_url = ''

  def image_url
    if @image_url.blank?
      @image_url = "coach/#{name.downcase.gsub(' ', '-')}.jpg"
      if CentralMarin::Application.assets.find_asset(@image_url).nil?
        @image_url = MISSING_COACH_URL
      end
    end
    return @image_url
  end

  def image_url=(url)
    @image_url = url
  end

  def admin_permalink
    admin_coach_path(self)
  end

  def to_s
    name
  end

  def as_json(options = {})
    { :name => self.name, :bio => self.bio, :teams => teams.as_json, :image_url => image_url }
  end

  class Translation
    include Rails.application.routes.url_helpers # needed for _path helpers to work in models

    attr_accessible :bio

    def admin_permalink
      admin_coach_path(self)
    end

    def to_s
      coach = Coach.find(self['coach_id'])
      coach.name
    end

  end
end

