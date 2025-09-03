CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777
  
  if Rails.env.production?
    # Production settings
    config.fog_credentials = {
      # Add your cloud storage credentials here if needed
    }
  else
    # Development and test
    config.enable_processing = Rails.env.development?
  end
end