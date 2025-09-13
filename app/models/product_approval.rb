class ProductApproval < ApplicationRecord
  belongs_to :product
  belongs_to :admin_user

  enum :status, {
    pending: 0,
    approved: 1,
    rejected: 2
  }

  enum :approval_type, {
    creation: 'creation',
    edit: 'edit'
  }

  validates :status, presence: true
  validates :approval_type, presence: true
  validates :reason, presence: true, if: :rejected?

  scope :pending_approvals, -> { where(status: :pending) }
  scope :for_product_creation, -> { where(approval_type: :creation) }
  scope :for_product_edit, -> { where(approval_type: :edit) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id product_id admin_user_id status reason approved_at approval_type created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product admin_user]
  end

  def approve!(admin_user, reason = nil)
    transaction do
      update!(
        status: :approved,
        admin_user: admin_user,
        approved_at: Time.current,
        reason: reason
      )
      
      # Activate the product when approved
      product.update!(is_active: true)
    end
  end

  def reject!(admin_user, reason)
    transaction do
      update!(
        status: :rejected,
        admin_user: admin_user,
        approved_at: Time.current,
        reason: reason
      )
      
      # Keep product inactive when rejected
      product.update!(is_active: false) if creation?
    end
  end

  def status_text
    case status
    when 'pending' then 'Chờ duyệt'
    when 'approved' then 'Đã duyệt'
    when 'rejected' then 'Từ chối'
    end
  end

  def approval_type_text
    case approval_type
    when 'creation' then 'Tạo sản phẩm'
    when 'edit' then 'Chỉnh sửa sản phẩm'
    end
  end
end