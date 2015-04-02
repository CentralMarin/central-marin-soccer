class Contact < ActiveRecord::Base

  active_admin_translates :position, :description, :bio

  IMAGE_WIDTH = 100
  IMAGE_HEIGHT = 121
  mount_uploader :image, ContactImageUploader
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :process_image
  after_create :process_image

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

protected
  def process_image
    unless image.nil?
      crop_image
      scale(IMAGE_WIDTH, IMAGE_HEIGHT)
    end
  end

  def crop_image
    if crop_x.present?
      image.manipulate! do |img|
        x = crop_x.to_i
        y = crop_y.to_i
        w = crop_w.to_i
        h = crop_h.to_i
        img.crop("#{w}x#{h}+#{x}+#{y}")
        img
      end
    end
  end

  def scale(width, height)
    image.resize_and_pad(width, height)
  end

end
