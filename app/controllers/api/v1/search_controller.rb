module Api
  module V1
    class SearchController < ApplicationController
      def products
        query = params[:q]
        
        if query.blank?
          render json: {
            success: true,
            products: [],
            total_count: 0,
            query: ""
          }
          return
        end

        # Limit search results to avoid performance issues
        limit = [(params[:limit] || 10).to_i, 20].min
        
        # Search products by name, description, and brand name
        search_term = "%#{ActiveRecord::Base.sanitize_sql_like(query)}%"
        exact_match_term = "#{ActiveRecord::Base.sanitize_sql_like(query)}%"
        
        products = Product.active
                          .includes(:brand, :category, :images)
                          .joins("LEFT JOIN brands ON products.brand_id = brands.id")
                          .where(
                            "products.name LIKE ? OR products.description LIKE ? OR products.short_description LIKE ? OR brands.name LIKE ?",
                            search_term, search_term, search_term, search_term
                          )
                          .limit(limit)
                          .order(Arel.sql("
                            CASE 
                              WHEN products.name LIKE '#{exact_match_term}' THEN 1
                              WHEN brands.name LIKE '#{exact_match_term}' THEN 2
                              WHEN products.short_description LIKE '#{exact_match_term}' THEN 3
                              ELSE 4
                            END,
                            products.view_count DESC,
                            products.created_at DESC
                          "))

        # Get total count for "View all results" link
        total_count = Product.active
                             .joins("LEFT JOIN brands ON products.brand_id = brands.id")
                             .where(
                               "products.name LIKE ? OR products.description LIKE ? OR products.short_description LIKE ? OR brands.name LIKE ?",
                               search_term, search_term, search_term, search_term
                             )
                             .count

        # Serialize products for the frontend
        products_data = products.map do |product|
          {
            id: product.id,
            name: product.name,
            slug: product.slug,
            price: product.price,
            image_url: product.primary_image_url,
            brand_name: product.brand&.name
          }
        end

        render json: {
          success: true,
          products: products_data,
          total_count: total_count,
          query: query
        }
      rescue => e
        Rails.logger.error "Search error: #{e.message}"
        Rails.logger.error e.backtrace[0..5].join("\n")
        
        render json: {
          success: false,
          products: [],
          total_count: 0,
          query: query || "",
          error: "Search failed"
        }, status: :internal_server_error
      end
    end
  end
end