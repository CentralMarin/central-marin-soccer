class CoachImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  module ImageSize
    WIDTH = 100
    HEIGHT = 118
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "default_coach_photo.jpeg"
  end

  # Process files as they are uploaded:
  process :crop_image
  process :scale => [ImageSize::WIDTH, ImageSize::HEIGHT]

  def crop_image
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        img.crop("#{w}x#{h}+#{x}+#{y}")
        img
      end
    end
  end

  def scale(width, height)
    resize_and_pad(width, height)
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg)
  end

end