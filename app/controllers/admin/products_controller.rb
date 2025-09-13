module Admin
  class ProductsController < Admin::ApplicationController
    before_action :set_current_admin_user

    def index
      @products = Product.includes(:brand, :category, :product_images)

      # Search functionality
      if params[:search].present?
        @products = @products.where("name ILIKE ? OR sku ILIKE ?",
                                  "%#{params[:search]}%",
                                  "%#{params[:search]}%")
      end

      # Filter by brand
      if params[:brand_id].present?
        @products = @products.where(brand_id: params[:brand_id])
      end

      # Filter by category
      if params[:category_id].present?
        @products = @products.where(category_id: params[:category_id])
      end

      # Filter by status
      if params[:status].present?
        case params[:status]
        when 'active'
          @products = @products.where(is_active: true)
        when 'inactive'
          @products = @products.where(is_active: false)
        when 'featured'
          @products = @products.where(is_essential_accessories: true)
        when 'new'
          @products = @products.where(is_new: true)
        when 'hot'
          @products = @products.where(is_hot: true)
        when 'preorder'
          @products = @products.where(is_preorder: true)
        when 'trending'
          @products = @products.where(is_trending: true)
        when 'ending_soon'
          @products = @products.where(is_ending_soon: true)
        when 'arriving_soon'
          @products = @products.where(is_arriving_soon: true)
        end
      end

      @products = @products.page(params[:page]).per(5)
      authorize_resource(resource_class)
    end

    def new
      resource = resource_class.new
      resource.is_active = false  # Set default to false
      resource.product_images.build
      resource.product_descriptions.build
      resource.product_specifications.build
      resource.product_videos.build
      authorize_resource(resource)
      @page_title = "Tạo Sản Phẩm Mới"
      render locals: { page: Administrate::Page::Form.new(dashboard, resource) }
    end

    def show
      @product = Product.find(params[:id])
      authorize_resource(@product)
    end

    def edit
      render locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) }
    end

    def create
      @product = Product.new(resource_params)
      authorize_resource(@product)

      if @product.save
        redirect_to admin_product_path(@product), notice: 'Product was successfully created.'
      else
        render :new
      end
    end

    def update
      @product = Product.find(params[:id])
      authorize_resource(@product)

      if @product.update(resource_params)
        redirect_to admin_product_path(@product), notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @product = Product.find(params[:id])
      authorize_resource(@product)
      @product.destroy
      redirect_to admin_products_path, notice: 'Product was successfully deleted.'
    end

    private

    def resource_params
      permitted_attrs = dashboard.permitted_attributes(action_name) + [
        :is_essential_accessories, :is_best_seller, :is_new, :is_hot, :is_preorder, :is_trending, :is_ending_soon, :is_arriving_soon,
        product_images_attributes: [:id, :image, :alt_text, :sort_order, :is_primary, :_destroy],
        product_descriptions_attributes: [:id, :title, :content, :sort_order, :_destroy],
        product_specifications_attributes: [:id, :spec_name, :spec_value, :unit, :sort_order, :_destroy],
        product_videos_attributes: [:id, :url, :title, :description, :sort_order, :is_active, :_destroy]
      ]

      # Only allow is_active for super_admin
      if current_admin_user&.super_admin?
        permitted_attrs << :is_active
      end

      params.require(resource_class.model_name.param_key).permit(permitted_attrs)
    end

    def set_current_admin_user
      Thread.current[:current_admin_user] = current_admin_user
    end
  end
end
