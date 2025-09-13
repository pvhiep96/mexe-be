require "administrate/base_dashboard"

class AdminUserDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    email: Field::String,
    role: Field::Select.with_options(
      collection: AdminUser.roles.keys.map { |role| [role.humanize, role] }
    ),
    client_name: Field::String,
    client_phone: Field::String,
    client_address: Field::Text,
    products: Field::HasMany,
    product_approvals: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    sign_in_count: Field::Number,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    email
    role
    client_name
    client_phone
    created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    email
    role
    client_name
    client_phone
    client_address
    created_at
    updated_at
    current_sign_in_at
    last_sign_in_at
    sign_in_count
  ].freeze

  FORM_ATTRIBUTES = %i[
    email
    role
    client_name
    client_phone
    client_address
  ].freeze

  COLLECTION_FILTERS = {
    super_admin: ->(resources) { resources.where(role: :super_admin) },
    client: ->(resources) { resources.where(role: :client) }
  }.freeze

  def display_resource(admin_user)
    admin_user.display_name
  end
end