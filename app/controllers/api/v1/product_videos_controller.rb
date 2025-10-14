module Api
  module V1
    class ProductVideosController < ApplicationController
      # GET /api/v1/product_videos/latest
      # Returns max 10 latest videos, one per product
      def latest
        # Get the latest video for each product
        # Using a subquery approach compatible with MySQL ONLY_FULL_GROUP_BY mode
        
        # First, get the max id for each product (which corresponds to latest video)
        subquery = ProductVideo
          .where(is_active: true)
          .select('product_id, MAX(id) as max_id')
          .group(:product_id)
          .to_sql
        
        # Then fetch those videos
        videos = ProductVideo
          .includes(product: [:brand, :category, :images])
          .joins("INNER JOIN (#{subquery}) latest ON product_videos.id = latest.max_id")
          .order(created_at: :desc)
          .limit(10)
        
        videos_data = videos.map do |video|
          ProductVideoSerializer.new(video).as_json.merge(
            product: {
              id: video.product.id,
              name: video.product.name,
              slug: video.product.slug,
              price: video.product.price,
              brand_name: video.product.brand&.name
            }
          )
        end
        
        render json: {
          success: true,
          data: videos_data
        }
      rescue => e
        Rails.logger.error "Latest videos error: #{e.message}"
        Rails.logger.error e.backtrace[0..5].join("\n")
        
        render json: {
          success: false,
          error: 'Failed to fetch latest videos',
          message: e.message
        }, status: :internal_server_error
      end
    end
  end
end

