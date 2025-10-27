module Api
  module V1
    class HomeController < ApplicationController
      def index
        cache_key = "home_index_response"
        cached_response = Rails.cache.fetch(cache_key, expires_in: 1.day) do
          categories = get_categories
          best_sellers = get_products_by_flag(:is_best_seller)
          early_order_products = get_early_order_products
          hot_special_offer = get_products_by_flag(:is_hot)
          essential_accessories = get_products_by_flag(:is_essential_accessories)


          # Log product details for best_sellers
          if best_sellers.any?
            Rails.logger.info "🏆 BEST SELLERS DETAILS:"
            best_sellers.each_with_index do |product, index|
              Rails.logger.info "  #{index + 1}. #{product.object.name} (ID: #{product.object.id}, Active: #{product.object.is_active}, Best Seller: #{product.object.is_best_seller})"
            end
          else
            Rails.logger.info "⚠️  NO BEST SELLERS FOUND!"
          end
          {
            success: true,
            data: {
              categories: categories,
              best_sellers: best_sellers,
              early_order_products: early_order_products,
              hot_special_offer: hot_special_offer,
              essential_accessories: essential_accessories
            }
          }
        end

        render json: cached_response
      end

      def get_early_order_products
        {
          trending_products: get_products_by_flag(:is_trending),
          new_products: get_products_by_flag(:is_new),
          ending_soon_products: get_products_by_flag(:is_ending_soon),
          arriving_soon_products: get_products_by_flag(:is_arriving_soon)
        }
      end

      private

      def get_categories
        categories = Category.includes(:children)
                           .root_categories
                           .active
                           .limit(6)

        categories.map do |category|
          {
            id: category.id,
            name: category.name,
            slug: category.slug,
            description: category.description,
            image_url: category.image,
            subcategories: category.children.active.limit(4).map do |sub|
              {
                id: sub.id,
                name: sub.name,
                slug: sub.slug,
                description: sub.description
              }
            end
          }
        end
      end


      def get_products_by_flag(flag_column)
        Rails.logger.info "🔍 Fetching products for flag: #{flag_column}"

        # Get raw products first for debugging
        raw_products = Product.active.includes(:brand, :category, :product_images)
                             .where(flag_column => true)
                             .order(created_at: :desc)
                             .limit(15)

        Rails.logger.info "  - Raw products count: #{raw_products.count}"
        Rails.logger.info "  - Raw products IDs: #{raw_products.pluck(:id, :name, :is_active, flag_column)}"

        # Check if any products have the flag set to true
        all_products_with_flag = Product.where(flag_column => true)
        Rails.logger.info "  - All products with #{flag_column}=true: #{all_products_with_flag.count}"
        Rails.logger.info "  - All products with #{flag_column}=true IDs: #{all_products_with_flag.pluck(:id, :name, :is_active, flag_column)}"

        # Check active products
        active_products = Product.active
        Rails.logger.info "  - All active products: #{active_products.count}"
        Rails.logger.info "  - All active products IDs: #{active_products.pluck(:id, :name, :is_active)}"

        ActiveModel::Serializer::CollectionSerializer.new(raw_products, serializer: ProductSerializer)
      end
    end
  end
end
