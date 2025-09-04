module Api
  module V1
    class HomeController < ApplicationController
      def index
        render json: {
          categories: get_categories,
          best_sellers: get_best_sellers,
          featured_products: get_featured_products,
          new_brands: get_new_brands,
          essential_accessories: get_essential_accessories
        }
      end

      def early_order
        trending_products = get_products_by_flag(:is_trending)
        new_products = get_products_by_flag(:is_new)
        ending_soon_products = get_products_by_flag(:is_ending_soon)
        arriving_soon_products = get_products_by_flag(:is_arriving_soon)

        render json: {
          success: true,
          data: {
            trending: trending_products,
            new_launched: new_products,
            ending_soon: ending_soon_products,
            arriving_soon: arriving_soon_products
          }
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

      def get_best_sellers
        products = Product.includes(:brand, :category, :product_images)
                        .active
                        .where('stock_quantity > 0')
                        .order(view_count: :desc, created_at: :desc)
                        .limit(8)

        ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer)
      end

      def get_featured_products
        products = Product.includes(:brand, :category, :product_images)
                        .active
                        .where('stock_quantity > 0')
                        .where('is_featured = ? OR is_new = ? OR is_hot = ? OR is_preorder = ?', true, true, true, true)
                        .order(created_at: :desc)
                        .limit(12)

        ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer)
      end

      def get_new_brands
        brands = Brand.includes(:products)
                     .active
                     .order(created_at: :desc)
                     .limit(6)

        brands.map do |brand|
          {
            id: brand.id,
            name: brand.name,
            slug: brand.slug,
            description: brand.description,
            logo_url: brand.logo,
            founded_year: brand.founded_year,
            field: brand.field,
            product_count: brand.products.active.count,
            featured_products: brand.products.includes(:product_images)
                                   .active
                                   .where('is_featured = ? OR is_new = ? OR is_hot = ?', true, true, true)
                                   .limit(3)
                                   .map { |p| ProductSerializer.new(p).as_json }
          }
        end
      end

      def get_essential_accessories
        # Lấy các sản phẩm phụ kiện cần thiết dựa trên category và đánh giá
        essential_categories = Category.active.where(slug: ['camera-hanh-trinh', 'tham-san', 'den-led', 'bao-ve'])
        
        products = Product.includes(:brand, :category, :product_images)
                        .active
                        .where('stock_quantity > 0')
                        .where(category: essential_categories)
                        .order(view_count: :desc, created_at: :desc)
                        .limit(8)

        ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer)
      end

      def get_products_by_flag(flag_column)
        products = Product.includes(:brand, :category, :product_images)
                         .where(is_active: true)
                         .where('stock_quantity > 0')
                         .where(flag_column => true)
                         .order(created_at: :desc)
                         .limit(15)

        ActiveModel::Serializer::CollectionSerializer.new(products, serializer: ProductSerializer)
      end
    end
  end
end
