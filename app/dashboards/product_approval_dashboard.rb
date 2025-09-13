require "administrate/base_dashboard"

class ProductApprovalDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    product: Field::BelongsTo,
    admin_user: Field::BelongsTo,
    status: Field::Select.with_options(
      collection: ProductApproval.statuses.keys.map { |status| [status.humanize, status] }
    ),
    reason: Field::Text,
    approval_type: Field::Select.with_options(
      collection: ProductApproval.approval_types.keys.map { |type| [type.humanize, type] }
    ),
    approved_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    product
    approval_type
    status
    admin_user
    created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    product
    approval_type
    status
    admin_user
    reason
    approved_at
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    product
    status
    reason
    approval_type
  ].freeze

  COLLECTION_FILTERS = {
    pending: ->(resources) { resources.where(status: :pending) },
    approved: ->(resources) { resources.where(status: :approved) },
    rejected: ->(resources) { resources.where(status: :rejected) },
    creation: ->(resources) { resources.where(approval_type: :creation) },
    edit: ->(resources) { resources.where(approval_type: :edit) }
  }.freeze

  def display_resource(product_approval)
    "#{product_approval.approval_type_text} - #{product_approval.product.name}"
  end
end