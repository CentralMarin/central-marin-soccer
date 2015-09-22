# encoding: utf-8

class ImageUploader < AssetUploader

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

  def scale(width, height)
    if file && model
      current_width, current_height = ::MiniMagick::Image.open(file.file)[:dimensions]
      resize_and_pad(width, height) unless width == current_width && height == current_height
    end
  end
end
