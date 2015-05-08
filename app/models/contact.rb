class Contact < ActiveRecord::Base

  extend CsvImport
  include RankedModel
  ranks :row_order

  active_admin_translates :club_position, :description, :bio

  validates :club_position, :presence => true
  validates :category, :presence => true
  validates :description, :presence => true

  enum category: [ :voting_board_member, :nonvoting_board_member, :other_assistance, :coaching ]

  def self.by_category
    results = {
        voting_board_member: Contact.where("category = ?", Contact.categories[:voting_board_member]).order(:row_order),
        nonvoting_board_member: Contact.where("category = ?", Contact.categories[:nonvoting_board_member]).order(:row_order),
        other_assistance: Contact.where("category = ?", Contact.categories[:other_assistance]).order(:row_order),
        coaching: Contact.where("category = ?", Contact.categories[:coaching]).order(:row_order),
    }
  end

  # Include the image processing module
  include ImageProcessing

  # Define Image dimensions
  IMAGE_WIDTH = 100
  IMAGE_HEIGHT = 121

  # Base file name for uploaded image
  def image_base_filename
    club_position
  end

  # Location to store images
  def image_store_dir
    "#{self.class.to_s.underscore}"
  end

end
