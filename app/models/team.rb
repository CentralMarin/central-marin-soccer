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

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  phone_regex = /^[+]?[1]?\(?[- .]?\d{3}\)?[- .]?\d{3}[- .]?\d{4}[ ]?[x]?[0-9]*$/

  default_scope :include => [:team_level, :coach]
  scope :academy, lambda {|year| where("year >= ?", year - ACADEMY_YEAR)}
  scope :boys, where(gender_id: 0).order([:year, :team_level_id])
  scope :girls, where(gender_id: 1).order([:year, :team_level_id])

  validates :year, :presence => true
  validates :gender, :presence => true
  validates :coach, :presence => true
  validates :manager_name, :presence => true,
            :length => { :maximum => 50 }
  validates :manager_email, :presence => true,
            :format => { :with => email_regex }
  validates :manager_phone, :presence => true,
            :format => { :with => phone_regex }
  validates :team_level, :presence => true

  attr_accessible :coach_id, :team_level_id, :gender, :year, :name, :manager_name, :manager_email, :manager_phone, :teamsnap_url

  def gender
    Team.genders[self.gender_id] unless gender_id.nil?
  end

  def gender=(gender)
    self.gender_id = Team.genders.index(gender) || Team.genders[0]
  end

  def page_title
    self.to_s
  end

  def age
    Time.now.year - year unless year.nil?
  end

  def two_digit_year
    year.to_s.last(2) unless year.nil?
  end

  def to_s
    "#{two_digit_year} #{gender} #{name} #{team_level.name} #{I18n.t('team.name.team')}" unless team_level.nil?
  end

  def admin_permalink
    admin_team_path(self)
  end

  def as_json(options = {})
    { :id => id, :name => to_s }
  end

  def to_param
    "#{id} #{to_s}".parameterize if id
  end

  def self.to_team_name_with_coach(id)
    Team.find(id).to_team_name_with_coach if id
  end

  def to_team_name_with_coach
    "#{to_s} coached by #{coach}"
  end

protected
  def self.genders
    [I18n.t('team.gender.boys'), I18n.t('team.gender.girls')]
  end

  ACADEMY_YEAR = 9
end

