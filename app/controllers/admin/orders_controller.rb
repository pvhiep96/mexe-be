module Admin
  class OrdersController < Admin::ApplicationController
    before_action :set_order, only: [:show, :update_shipping]

    def index
      @orders = filtered_orders.includes(:user, :products, :order_items)
                              .order(created_at: :desc)
                              .page(params[:page])
    end

    def show
      @can_update_shipping = can_update_shipping_info?(@order)
    end

    def update_shipping
      unless can_update_shipping_info?(@order)
        redirect_to admin_order_path(@order), alert: 'Bạn không có quyền cập nhật thông tin vận chuyển cho đơn hàng này.'
        return
      end

      if @order.update(shipping_params)
        @order.update(
          shipped_at: Time.current,
          status_processed: :shipped_to_carrier
        )
        redirect_to admin_order_path(@order), notice: 'Đã cập nhật thông tin vận chuyển thành công.'
      else
        render :show, alert: 'Có lỗi xảy ra khi cập nhật thông tin vận chuyển.'
      end
    end

    private

    def set_order
      @order = filtered_orders.find(params[:id])
    end

    def filtered_orders
      if current_admin_user.super_admin?
        Order.all
      else
        # Client chỉ thấy orders chứa sản phẩm của họ
        Order.joins(:products).where(products: { client_id: current_admin_user.id }).distinct
      end
    end

    def can_update_shipping_info?(order)
      return true if current_admin_user.super_admin?
      
      # Client chỉ có thể cập nhật nếu order chứa sản phẩm của họ và chưa được xử lý
      order.contains_products_from_client?(current_admin_user) && 
      order.processing_not_processed?
    end

    def shipping_params
      params.require(:order).permit(:shipping_provider, :tracking_number, :tracking_url, :notes)
    end
  end
end