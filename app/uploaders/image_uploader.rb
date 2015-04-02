# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  def filename
    if (defined? model.image_base_filename).nil? or file.nil?
      super
    else
      "#{model.image_base_filename}.#{file.extension}"
    end
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if (defined? model.image_store_dir).nil?
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{defined? model.image_store_dir}"
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg png)
  end

  def default_url
    if (defined? model.default_image_url).nil?
      super
    else
      model.default_image_url
    end
  end
end
