module Api
  module V1
    class HomeController < ApplicationController
      def index
        render json: {
          success: true,
          data: {
            categories: get_categories,
            best_sellers: get_products_by_flag(:is_best_seller),
            early_order_products: get_early_order_products,
            hot_special_offer: get_products_by_flag(:is_hot),
            essential_accessories: get_products_by_flag(:is_essential_accessories)
          }
        }
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
        products = Product.active.includes(:brand, :category, :product_images)
                         .where(flag_column => true)
                         .order(created_at: :desc)
                         .limit(15)

        ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer)
      end
    end
  end
end
