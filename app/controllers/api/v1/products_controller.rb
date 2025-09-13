module Api
  module V1
    class ProductsController < ApplicationController
      def index
        page = (params[:page] || 1).to_i
        per_page = (params[:per_page] || 20).to_i

        products = Product.active.includes(:brand, :category, :images, :variants, :specifications)
                          .search_by_query(params[:search])
                          .filter_by_category(params[:category_id])
                          .filter_by_brand(params[:brand_id])
                          
        # Apply additional filters
        products = products.where(is_new: true) if params[:is_new] == 'true'
        products = products.where(is_hot: true) if params[:is_hot] == 'true'
        products = products.where(is_featured: true) if params[:is_featured] == 'true'
        
        # Apply sorting
        products = case params[:sort]
                  when 'price_asc'
                    products.order(:price)
                  when 'price_desc'
                    products.order(price: :desc)
                  when 'name_asc'
                    products.order(:name)
                  when 'name_desc'
                    products.order(name: :desc)
                  when 'newest'
                    products.order(created_at: :desc)
                  when 'oldest'
                    products.order(created_at: :asc)
                  else
                    # If search query exists, keep search ordering, otherwise default ordering
                    params[:search].present? ? products : products.order(created_at: :desc)
                  end
        
        # Apply pagination
        products = products.page(page).per(per_page)

        products_data = products.map do |product|
          ProductSerializer.new(product).as_json
        end

        render json: {
          products: products_data,
          meta: {
            total: products.total_count,
            page: page,
            per_page: per_page,
            total_pages: products.total_pages
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
      product = Product.includes(:brand, :category, :images, :variants, :specifications, :descriptions, :videos)
                        .find_by(id: params[:id]) ||
                Product.includes(:brand, :category, :images, :variants, :specifications, :descriptions, :videos)
                        .find_by(slug: params[:id])

        if product
          render json: ProductDetailSerializer.new(product).as_json
        else
          render json: { error: 'Product not found' }, status: :not_found
        end
      end
    end
  end
end
