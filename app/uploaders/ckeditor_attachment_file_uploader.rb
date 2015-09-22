# encoding: utf-8
class CkeditorAttachmentFileUploader < AssetUploader
  include Ckeditor::Backend::CarrierWave

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    Ckeditor.attachment_file_types
  end
end
