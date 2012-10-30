# == Schema Information
#
# Table name: team_levels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TeamLevel < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  translates :name, versioning: true
  accepts_nested_attributes_for :translations, :allow_destroy => true
  has_many :team_level_translations

  has_many :teams

  attr_accessible :name, :translations_attributes

  def admin_permalink
    admin_team_level_path(self)
  end

  def to_s
    name
  end
end
