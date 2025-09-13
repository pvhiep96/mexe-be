module Admin
  class AnalyticsController < Admin::ApplicationController
    before_action :set_date_range
    
    def index
      if current_admin_user&.super_admin?
        @total_revenue = calculate_total_revenue
        @npp_revenue_breakdown = calculate_npp_revenue_breakdown
        @monthly_revenue = calculate_monthly_revenue
        @top_selling_products = get_top_selling_products
        @recent_orders = get_recent_orders
        @revenue_by_payment_method = calculate_revenue_by_payment_method
      elsif current_admin_user&.client?
        redirect_to admin_client_analytics_path
      else
        redirect_to admin_root_path, alert: "Không có quyền truy cập báo cáo"
      end
    end

    def client_analytics
      unless current_admin_user&.client?
        redirect_to admin_root_path, alert: "Chỉ NPP mới có thể xem báo cáo của mình"
        return
      end

      @client_revenue = calculate_client_revenue(current_admin_user)
      @client_orders = get_client_orders(current_admin_user)
      @client_products = get_client_products_stats(current_admin_user)
      @monthly_client_revenue = calculate_monthly_client_revenue(current_admin_user)
    end

    def npp_detail
      unless current_admin_user&.super_admin?
        redirect_to admin_root_path, alert: "Chỉ Super Admin mới có thể xem chi tiết NPP"
        return
      end

      @npp = AdminUser.client.find(params[:npp_id])
      @npp_revenue = calculate_client_revenue(@npp)
      @npp_orders = get_client_orders(@npp)
      @npp_products = get_client_products_stats(@npp)
      @monthly_npp_revenue = calculate_monthly_client_revenue(@npp)
    end

    private

    def set_date_range
      @start_date = params[:start_date]&.to_date || 30.days.ago
      @end_date = params[:end_date]&.to_date || Date.current
    end

    def calculate_total_revenue
      Order.joins(:order_items)
           .where(created_at: @start_date..@end_date, status: ['delivered', 'paid'])
           .sum('order_items.quantity * order_items.unit_price')
    end

    def calculate_npp_revenue_breakdown
      AdminUser.client.includes(:products).map do |npp|
        revenue = Order.joins(order_items: :product)
                      .where(products: { client_id: npp.id })
                      .where(orders: { created_at: @start_date..@end_date, status: ['delivered', 'paid'] })
                      .sum('order_items.quantity * order_items.unit_price')
        
        {
          npp: npp,
          revenue: revenue,
          percentage: calculate_percentage(revenue, calculate_total_revenue)
        }
      end.sort_by { |item| -item[:revenue] }
    end

    def calculate_monthly_revenue
      Order.joins(:order_items)
           .where(created_at: @start_date..@end_date, status: ['delivered', 'paid'])
           .group("DATE_TRUNC('month', orders.created_at)")
           .sum('order_items.quantity * order_items.unit_price')
           .transform_keys { |date| date.strftime('%B %Y') }
    end

    def calculate_client_revenue(client)
      Order.joins(order_items: :product)
           .where(products: { client_id: client.id })
           .where(orders: { created_at: @start_date..@end_date, status: ['delivered', 'paid'] })
           .sum('order_items.quantity * order_items.unit_price')
    end

    def calculate_monthly_client_revenue(client)
      Order.joins(order_items: :product)
           .where(products: { client_id: client.id })
           .where(orders: { created_at: @start_date..@end_date, status: ['delivered', 'paid'] })
           .group("DATE_TRUNC('month', orders.created_at)")
           .sum('order_items.quantity * order_items.unit_price')
           .transform_keys { |date| date.strftime('%B %Y') }
    end

    def get_client_orders(client)
      Order.joins(order_items: :product)
           .where(products: { client_id: client.id })
           .where(created_at: @start_date..@end_date)
           .distinct
           .order(created_at: :desc)
           .limit(10)
    end

    def get_client_products_stats(client)
      {
        total_products: client.products.count,
        active_products: client.products.where(is_active: true).count,
        pending_approval: client.products.joins(:product_approvals)
                                        .where(product_approvals: { status: 'pending' }).count
      }
    end

    def get_top_selling_products
      Product.joins(:order_items)
             .joins("INNER JOIN orders ON orders.id = order_items.order_id")
             .where(orders: { created_at: @start_date..@end_date, status: ['delivered', 'paid'] })
             .group('products.id', 'products.name')
             .sum('order_items.quantity')
             .sort_by { |_, quantity| -quantity }
             .first(10)
             .map { |product_data, quantity| { product: Product.find(product_data[0]), quantity: quantity } }
    end

    def get_recent_orders
      scope = current_admin_user&.super_admin? ? Order.all : Order.joins(order_items: :product).where(products: { client_id: current_admin_user.id }).distinct
      
      scope.where(created_at: @start_date..@end_date)
           .order(created_at: :desc)
           .limit(10)
    end

    def calculate_revenue_by_payment_method
      Order.joins(:order_items)
           .where(created_at: @start_date..@end_date, status: ['delivered', 'paid'])
           .group(:payment_method)
           .sum('order_items.quantity * order_items.unit_price')
    end

    def calculate_percentage(value, total)
      return 0 if total.zero?
      ((value.to_f / total) * 100).round(2)
    end
  end
end