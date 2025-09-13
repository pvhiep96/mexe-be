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

    protected

    def authorize_resource(resource)
      case resource
      when Class
        authorize_resource_class(resource)
      when Product
        authorize_product(resource)
      else
        # Default authorization for other resources
        return true if current_admin_user&.super_admin?
      end
    end

    private

    def authorize_resource_class(resource_class)
      case resource_class.name
      when 'Product'
        return true if current_admin_user&.can_manage_products?
        raise_authorization_error("Bạn không có quyền quản lý sản phẩm")
      when 'Order'
        return true if current_admin_user&.can_manage_orders?
        raise_authorization_error("Bạn không có quyền quản lý đơn hàng")
      when 'AdminUser'
        return true if current_admin_user&.can_manage_admin_users?
        raise_authorization_error("Chỉ Super Admin mới có quyền quản lý tài khoản")
      when 'ProductApproval'
        return true if current_admin_user&.can_approve_products?
        raise_authorization_error("Chỉ Super Admin mới có quyền duyệt sản phẩm")
      else
        return true if current_admin_user&.super_admin?
        raise_authorization_error("Bạn không có quyền truy cập tính năng này")
      end
    end

    def authorize_product(product)
      if current_admin_user&.super_admin?
        return true
      elsif current_admin_user&.client?
        # Client can only access their own products
        if product.persisted? && product.client_id != current_admin_user.id
          raise_authorization_error("Bạn chỉ có thể truy cập sản phẩm của mình")
        end
        # Set client_id for new products
        product.client_id = current_admin_user.id if product.new_record?
        return true
      else
        raise_authorization_error("Bạn không có quyền truy cập sản phẩm")
      end
    end

    def raise_authorization_error(message)
      redirect_to admin_root_path, alert: message
    end


    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
