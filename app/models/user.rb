# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  ROLES = [:admin, :board_member, :team_manager, :field_manager, :coach]

  has_paper_trail

  validates :email, :presence =>true,
            :uniqueness=>true

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  def admin_permalink
    admin_user_path(self)
  end

  def to_s
    email
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles

  after_create { |admin| admin.send_reset_password_instructions }

  def roles=(roles)
    roles = roles.collect {|r| r.to_sym} unless roles.length > 0 && roles[0].kind_of?(Symbol)
    self.roles_mask = (roles & ROLES).map do |r|
      2**ROLES.index(r) # Get integer representation of bits
    end.inject(0, :+) # Add all to get an int we can store in the db
  end

  def roles
    # return an array of the roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def self.show_role(role)
    role.capitalize
  end

  def self.show_roles
    ROLES.collect {|role| User.show_role(role)}
  end

  def show_roles
    self.roles.collect {|role| User.show_role(role) }.join(', ')
  end

protected
  # TODO: See if we can remove password from attr_accessible
  def password_required?
    new_record? ? false : super
  end

end


