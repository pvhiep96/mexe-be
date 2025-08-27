class ProductsController < ApplicationController
  def index
    @products = Product.where(is_active: true).includes(:brand, :category)
  end

  def show
    @product = Product.find_by!(slug: params[:id])
    @related_products = Product.where(category: @product.category, is_active: true)
                              .where.not(id: @product.id)
                              .limit(4)
                              .includes(:brand)
  end

  def test
    @product = Product.find(params[:id])
    render :test, layout: false
  end
end
