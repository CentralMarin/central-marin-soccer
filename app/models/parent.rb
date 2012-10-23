# == Schema Information
#
# Table name: parents
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  home_phone :string(255)
#  cell_phone :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Parent < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  has_paper_trail

  has_and_belongs_to_many :players, :join_table => :parents_players

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  phone_regex = /^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/

  validates :name,         :presence => true,
                           :length => { :maximum => 50 }
  validates :email,        :presence => true,
                           :format => { :with => email_regex },
                           :uniqueness => { :case_sensitive => false }
  validates :home_phone,   :presence => true,
                           :format => { :with => phone_regex }
  validates :cell_phone,   :format => { :with => phone_regex }

  def admin_permalink
    admin_parent_path(self)
  end

  def to_s
    name
  end
end
