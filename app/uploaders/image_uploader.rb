class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  def store_dir
    if ENV['USE_CLOUD_STORAGE'] == 'true'
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id || "tmp_#{Time.now.to_i}"}"
    end
  end

  # Process files as they are uploaded:
  process resize_to_limit: [800, 800]

  # Create different versions of your uploaded files:
  version :large do
    process resize_to_limit: [800, 600]
  end

  version :medium do
    process resize_to_limit: [400, 300]
  end

  version :thumb do
    process resize_to_limit: [200, 150]
  end

  version :small do
    process resize_to_limit: [100, 75]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg png webp)
  end

  # Override the filename of the uploaded files:
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  private

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
