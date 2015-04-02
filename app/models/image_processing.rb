module ImageProcessing

  mattr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def self.included(base)
    base.class_eval do
      mount_uploader :image, ImageUploader
      after_update :process_image
      after_create :process_image
    end
  end

  protected

  def process_image
    unless image.nil?
      crop_image
      scale(self.class::IMAGE_WIDTH, self.class::IMAGE_HEIGHT)
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
