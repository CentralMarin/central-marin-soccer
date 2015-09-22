CarrierWave.configure do |config|
  config.permissions = 0755
  config.directory_permissions = 0777
  config.storage = :file
  config.store_dir = "uploads/"
end