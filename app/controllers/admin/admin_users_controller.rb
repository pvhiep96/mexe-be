module Admin
  class AdminUsersController < Admin::ApplicationController
    before_action :ensure_super_admin
    before_action :set_admin_user, only: [:show, :edit, :update, :destroy]

    def index
      @admin_users = AdminUser.order(created_at: :desc)
      
      # Filter by role if provided
      if params[:role].present?
        @admin_users = @admin_users.where(role: params[:role])
      end
      
      # Search by email if provided
      if params[:search].present?
        @admin_users = @admin_users.where("email LIKE ?", "%#{params[:search]}%")
      end
      
      # Pagination
      @admin_users = @admin_users.page(params[:page]).per(20)
    end

    def show
      @products_count = @admin_user.products.count
      @orders_count = @admin_user.orders_as_client.count
      @recent_products = @admin_user.products.order(created_at: :desc).limit(5)
    end

    def new
      @admin_user = AdminUser.new
    end

    def create
      @admin_user = AdminUser.new(admin_user_params)
      
      # Generate random password if not provided
      if @admin_user.password.blank?
        @admin_user.password = generate_random_password
        @admin_user.password_confirmation = @admin_user.password
        generated_password = @admin_user.password
      else
        generated_password = nil
      end
      
      if @admin_user.save
        # Send email with credentials (implement this later)
        notice_message = "Đã tạo tài khoản #{@admin_user.role == 'super_admin' ? 'Super Admin' : 'NPP'} cho #{@admin_user.email}"
        if generated_password
          notice_message += ". Mật khẩu tạm thời: #{generated_password}"
        end
        redirect_to admin_admin_user_path(@admin_user), notice: notice_message
      else
        render :new
      end
    end

    def edit
    end

    def update
      # Don't update password if it's blank
      update_params = admin_user_params
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end
      
      if @admin_user.update(update_params)
        redirect_to admin_admin_user_path(@admin_user), notice: "Đã cập nhật thông tin tài khoản #{@admin_user.email}"
      else
        render :edit
      end
    end

    def destroy
      if @admin_user == current_admin_user
        redirect_to admin_admin_user_path(@admin_user), 
                    alert: "Không thể xóa tài khoản hiện tại của bạn"
        return
      end
      
      @admin_user.destroy
      redirect_to admin_admin_users_path, notice: "Đã xóa tài khoản #{@admin_user.email}"
    end

    def grant_access
      @admin_user = AdminUser.find(params[:id])
      # Logic to grant access - could be enabling account, changing role, etc.
      redirect_to admin_admin_user_path(@admin_user), notice: "Đã cấp quyền truy cập"
    end

    def revoke_access
      @admin_user = AdminUser.find(params[:id])
      # Logic to revoke access
      redirect_to admin_admin_user_path(@admin_user), notice: "Đã thu hồi quyền truy cập"
    end

    def reset_password
      @admin_user = AdminUser.find(params[:id])
      new_password = generate_random_password
      
      if @admin_user.update(password: new_password, password_confirmation: new_password)
        redirect_to admin_admin_user_path(@admin_user), 
                    notice: "Đã đặt lại mật khẩu cho #{@admin_user.email}. Mật khẩu mới: #{new_password}"
      else
        redirect_to admin_admin_user_path(@admin_user), 
                    alert: "Không thể đặt lại mật khẩu. Vui lòng thử lại."
      end
    end

    private

    def set_admin_user
      @admin_user = AdminUser.find(params[:id])
    end

    def admin_user_params
      params.require(:admin_user).permit(:email, :password, :password_confirmation, :role, :client_name, :client_phone, :client_address)
    end

    def generate_random_password
      SecureRandom.alphanumeric(12)
    end

    def ensure_super_admin
      unless current_admin_user&.super_admin?
        redirect_to admin_root_path, alert: "Chỉ Super Admin mới có quyền quản lý tài khoản NPP"
      end
    end
  end
end