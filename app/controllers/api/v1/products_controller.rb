module Api
  module V1
    class ProductsController < ApplicationController
      def index
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 20).to_i
        
        products = Product.includes(:brand, :category, :images, :variants, :specifications)
                          .where(is_active: true)
                          .page(page)
                          .per(per_page)
        
        products_data = products.map do |product|
          ProductSerializer.new(product).as_json
        end
        
        render json: {
          products: products_data,
          meta: {
            total: Product.where(is_active: true).count,
            page: page,
            per_page: per_page,
            total_pages: (Product.where(is_active: true).count.to_f / per_page).ceil
          }
        }
      rescue => e
        Rails.logger.error "Products index error: #{e.message}"
        Rails.logger.error e.backtrace[0..5].join("\n")
        
        render json: {
          error: 'Failed to fetch products',
          message: e.message
        }, status: :internal_server_error
      end

      def show
        product = Product.find_by(id: params[:id]) || Product.find_by(slug: params[:id])
        
        if product
          render json: ProductDetailSerializer.new(product).as_json
        else
          render json: { error: 'Product not found' }, status: :not_found
        end
      end
    end
  end
end
