module Admin
  class NotificationsController < Admin::ApplicationController
    before_action :ensure_client_role

    def index
      @notifications = current_admin_user.client_notifications
                                        .includes(:order)
                                        .recent
                                        .page(params[:page])
      @unread_count = current_admin_user.client_notifications.unread.count
    end

    def show
      @notification = current_admin_user.client_notifications.find(params[:id])
      @notification.mark_as_read! unless @notification.is_read?
    end

    def mark_as_read
      @notification = current_admin_user.client_notifications.find(params[:id])
      @notification.mark_as_read!
      redirect_to admin_notifications_path, notice: 'Đã đánh dấu thông báo đã đọc.'
    end

    def mark_all_as_read
      current_admin_user.client_notifications.unread.update_all(
        is_read: true, 
        read_at: Time.current
      )
      redirect_to admin_notifications_path, notice: 'Đã đánh dấu tất cả thông báo đã đọc.'
    end

    private

    def ensure_client_role
      redirect_to admin_orders_path unless current_admin_user.client?
    end
  end
end