# encoding: utf-8
# == Schema Information
#
# Table name: teams
#
#  id            :integer          not null, primary key
#  age           :integer
#  gender        :string(255)
#  name          :string(255)
#  coach_id      :integer
#  team_level_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#


class Team < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  has_paper_trail

  belongs_to :coach
  belongs_to :team_level

  default_scope :include => [:team_level, :coach]

  validates :age, :presence => true,
      :numericality => {
          :greater_than_or_equal_to => 8,
          :less_than_or_equal_to => 18 }
  validates :gender, :presence => true
  validates :coach, :presence => true
  validates :team_level, :presence => true

  GENDERS = ['Boys', 'Girls']
  SPANISH_GENDERS = ['Niños', 'Niñas']

  def page_title
    self.to_s
  end

  def to_s
    if I18n.locale == :es
      "U#{age} #{gender == GENDERS[0]? SPANISH_GENDERS[0] : SPANISH_GENDERS[1]} #{name} Equipo de #{team_level.name}"
    else
      "U#{age} #{gender} #{name} #{team_level.name} Team"
    end
  end

  def admin_permalink
    admin_team_path(self)
  end

  def as_json(options = {})
    { :id => id, :name => to_s }
  end

  def to_param
    "#{id} #{to_s}".parameterize
  end

  def self.to_team_name_with_coach(id)
    Team.find(id).to_team_name_with_coach if id
  end

  def to_team_name_with_coach
    "#{to_s} coached by #{coach}"
  end
end

