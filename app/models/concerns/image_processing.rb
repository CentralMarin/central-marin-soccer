module ImageProcessing

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  def self.included(base)
    base.class_eval do
      mount_uploader :image, ImageUploader
      before_validation :process_image
    end
  end

  protected

  def process_image
    if image?
      crop_image
      image.scale(self.class::IMAGE_WIDTH, self.class::IMAGE_HEIGHT)
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

        # Clear the crop data
        crop_x = crop_y = crop_w = crop_h = nil
        img
      end
    end
  end
end
