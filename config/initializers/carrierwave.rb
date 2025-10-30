if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
    config.root = Rails.root.join('tmp')
  end
elsif Rails.env.production? || ENV['USE_CLOUD_STORAGE'] == 'true'
  CarrierWave.configure do |config|
    # config.storage = :fog
    # Add your fog credentials and settings here for production
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:                ENV['AWS_REGION'], # e.g. "ap-southeast-1"
    }
    config.fog_directory  = ENV['AWS_BUCKET']
    config.fog_public     = true  # false = private files
  end
else
  CarrierWave.configure do |config|
    config.permissions = 0666
    config.directory_permissions = 0777

    # Ensure temp directory is accessible
    config.root = Rails.root.join('public')
    config.cache_dir = Rails.root.join('tmp/uploads')

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

end
