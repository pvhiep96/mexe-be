module Admin
  class ProductApprovalsController < Admin::ApplicationController
    before_action :ensure_super_admin
    before_action :set_product_approval, only: [:show, :approve, :reject]

    def index
      @q = ProductApproval.includes(:product, :admin_user).ransack(params[:q])
      @product_approvals = @q.result.order(created_at: :desc).page(params[:page]).per(20)
      
      # Filter by status if provided
      if params[:status].present?
        @product_approvals = @product_approvals.where(status: params[:status])
      end
    end

    def show
      @product = @product_approval.product
    end

    def approve
      reason = params[:reason].presence || "Sản phẩm đã được duyệt"
      
      if @product_approval.approve!(current_admin_user, reason)
        redirect_to admin_product_approvals_path, 
                    notice: "Đã duyệt sản phẩm '#{@product_approval.product.name}'"
      else
        redirect_to admin_product_approval_path(@product_approval),
                    alert: "Không thể duyệt sản phẩm. Vui lòng thử lại."
      end
    end

    def reject
      reason = params[:reason]
      
      if reason.blank?
        redirect_to admin_product_approval_path(@product_approval),
                    alert: "Vui lòng nhập lý do từ chối"
        return
      end
      
      if @product_approval.reject!(current_admin_user, reason)
        redirect_to admin_product_approvals_path,
                    notice: "Đã từ chối sản phẩm '#{@product_approval.product.name}'"
      else
        redirect_to admin_product_approval_path(@product_approval),
                    alert: "Không thể từ chối sản phẩm. Vui lòng thử lại."
      end
    end

    private

    def set_product_approval
      @product_approval = ProductApproval.find(params[:id])
    end

    def ensure_super_admin
      unless current_admin_user&.super_admin?
        redirect_to admin_root_path, alert: "Chỉ Super Admin mới có quyền duyệt sản phẩm"
      end
    end
  end
end