class CkeditorUploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!

  def create
    if params[:upload].present?
      file = params[:upload]

      # Validate file type
      allowed_types = %w[image/jpeg image/png image/gif image/bmp image/webp image/tiff image/svg+xml]
      unless allowed_types.include?(file.content_type)
        return render json: { error: { message: 'Invalid file type. Only images are allowed.' } }, status: 400
      end

      # Validate file size (max 10MB)
      max_size = 10.megabytes
      if file.size > max_size
        return render json: { error: { message: 'File too large. Maximum size is 10MB.' } }, status: 400
      end

      # Generate unique filename
      filename = "#{SecureRandom.uuid}_#{file.original_filename}"

      # Save file to Active Storage
      begin
        blob = ActiveStorage::Blob.create_and_upload!(
          io: file.open,
          filename: filename,
          content_type: file.content_type
        )

        # Return success response in CKEditor 5 format
        render json: {
          url: rails_blob_url(blob),
          uploaded: 1,
          fileName: filename
        }
      rescue => e
        Rails.logger.error "CKEditor upload error: #{e.message}"
        render json: { error: { message: 'Failed to upload file.' } }, status: 500
      end
    else
      render json: { error: { message: 'No file provided.' } }, status: 400
    end
  end

  private

  def authenticate_admin_user!
    unless admin_user_signed_in?
      render json: { error: { message: 'Authentication required.' } }, status: 401
    end
  end
end
