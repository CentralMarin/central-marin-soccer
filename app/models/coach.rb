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

  translates :bio, versioning: true
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

  def image_url
    "/assets/coach/#{name.downcase.gsub(' ', '-')}.jpg"
  end

  def admin_permalink
    admin_coach_path(self)
  end

  def to_s
    name
  end

  def as_json(options = {})
    { :name => self.name, :bio => self.bio, :teams => teams.as_json }
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

