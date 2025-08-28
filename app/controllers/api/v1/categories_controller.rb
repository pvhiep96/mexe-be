class Api::V1::CategoriesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    categories = Category.all
    # render json: CategorySerializer.new(categories).to_json
    # render json: categories, each_serializer: CategorySerializer,
    render json: categories.to_json
  end

  def show
    category = Category.find(params[:id])
    render json: CategorySerializer.new(category).serializable_hash
  end

  # Get categories with subcategories for banner
  def banner_data
    root_categories = Category.active.root_categories
                             .includes(:subcategories)
                             .order(:sort_order, :name)

    categories_data = root_categories.map do |category|
      {
        id: category.id,
        name: category.name,
        slug: category.slug,
        href: category_products_path(category.slug),
        subcategories: category.subcategories.active.order(:sort_order, :name).map do |sub|
          {
            id: sub.id,
            name: sub.name,
            slug: sub.slug,
            href: category_products_path(sub.slug)
          }
        end
      }
    end

    render json: { data: categories_data }
  end

  private

  def category_products_path(slug)
    "/products?category=#{slug}"
  end
end
