# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    def authenticate_admin
      authenticate_admin_user!
    end

    def index
      # Admin dashboard home page
      if current_admin_user.super_admin?
        @product_count = Product.count
        @order_count = Order.count
        @pending_orders = Order.processing_not_processed.count
      else
        @product_count = current_admin_user.products.count
        @order_count = Order.joins(:products).where(products: { client_id: current_admin_user.id }).distinct.count
        @pending_orders = Order.joins(:products)
                              .where(products: { client_id: current_admin_user.id })
                              .processing_not_processed
                              .distinct.count
      end
      
      @brand_count = Brand.count rescue 0
      @category_count = Category.count rescue 0
      @recent_products = current_admin_user.super_admin? ? 
                        Product.order(created_at: :desc).limit(5) :
                        current_admin_user.products.order(created_at: :desc).limit(5)
    end

    private

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
