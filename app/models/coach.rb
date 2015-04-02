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

  before_validation :downcase_email

  active_admin_translates :bio

  has_many :teams

  email_regex = /\A['\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,         :presence => true,
                           :length => { :maximum => 50 }
  validates :email,        :presence => true,
                           :format => { :with => email_regex },
                           :uniqueness => true

  def to_s
    name
  end

  def as_json(options = {})
    { :name => self.name, :bio => self.bio, :teams => teams.as_json, :image_url => options[:image_url] }
  end

  # Include the image processing module
  include ImageProcessing

  # Define Image dimensions
  IMAGE_WIDTH = 100
  IMAGE_HEIGHT = 118

  def default_image_url
    "default_coach_photo.jpeg"
  end

  private

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end
end

