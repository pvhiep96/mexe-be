module Api
  module V1
    class ProductsController < ApplicationController
      def index
        products = Product.where(is_active: params[:is_active] || true)
                         .includes(:brand, :category)
                         .filter_by_category(params[:category_id])
                         .filter_by_brand(params[:brand_id])
                         .page(params[:page]).per(params[:per_page] || 20)

        render json: {
          products: ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer),
          meta: {
            total: products.total_count,
            page: params[:page] || 1,
            per_page: params[:per_page] || 20
          }
        }
      end

      def show
        product = Product.find_by(id: params[:id]) || Product.find_by!(slug: params[:id])
        render json: ProductDetailSerializer.new(product).as_json
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end
    end
  end
end
