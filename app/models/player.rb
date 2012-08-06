# == Schema Information
#
# Table name: players
#
#  id         :integer         not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Player < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  has_paper_trail

  has_and_belongs_to_many :parents, :join_table => :parents_players

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :parents, :presence => true

  def admin_permalink
    admin_player_path(self)
  end

  def to_s
    "#{first_name} #{last_name}"
  end
end
