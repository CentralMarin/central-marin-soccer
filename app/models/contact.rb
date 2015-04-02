class Contact < ActiveRecord::Base

  active_admin_translates :position, :description, :bio

  validates :position, :presence => true
  validates :category, :presence => true
  validates :description, :presence => true

  enum category: [ :voting_board_member, :nonvoting_board_member, :other_assistance, :coaching ]

  def self.by_category
    results = {
        voting_board_member: Contact.where("category = ?", Contact.categories[:voting_board_member]),
        nonvoting_board_member: Contact.where("category = ?", Contact.categories[:nonvoting_board_member]),
        other_assistance: Contact.where("category = ?", Contact.categories[:other_assistance]),
        coaching: Contact.where("category = ?", Contact.categories[:coaching]),
    }
  end
end
