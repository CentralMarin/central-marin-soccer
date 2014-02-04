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

  before_validation :downcase_email

  active_admin_translates :bio

  has_many :teams

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_coach_image
  mount_uploader :image, CoachImageUploader

  email_regex = /\A['\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,         :presence => true,
                           :length => { :maximum => 50 }
  validates :email,        :presence => true,
                           :format => { :with => email_regex },
                           :uniqueness => true
  #
  #def admin_permalink
  #  admin_coach_path(self)
  #end

  def crop_coach_image
    image.recreate_versions! if crop_x.present?
  end

  def to_s
    name
  end

  def as_json(options = {})
    { :name => self.name, :bio => self.bio, :teams => teams.as_json, :image_url => options[:image_url] }
  end

  private

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
end

