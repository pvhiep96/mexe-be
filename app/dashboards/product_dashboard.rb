require "administrate/base_dashboard"

class ProductDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    brand: Field::BelongsTo,
    category: Field::BelongsTo,
    name: Field::String,
    slug: Field::String,
    sku: Field::String,
    description: Field::Text,
    short_description: Field::Text,
    price: Field::String.with_options(searchable: false),
    original_price: Field::String.with_options(searchable: false),
    discount_percent: Field::Number,
    stock_quantity: Field::Number,
    min_stock_alert: Field::Number,
    warranty_period: Field::String,
    is_active: Field::Boolean,
    is_essential_accessories: Field::Boolean,
    is_new: Field::Boolean,
    is_hot: Field::Boolean,
    is_preorder: Field::Boolean,
    preorder_quantity: Field::Number,
    preorder_end_date: Field::DateTime,
    meta_title: Field::String,
    meta_description: Field::Text,
    view_count: Field::Number,
    # Payment options
    full_payment_transfer: Field::Boolean,
    full_payment_discount_percentage: Field::Number,
    partial_advance_payment: Field::Boolean,
    advance_payment_percentage: Field::Number,
    advance_payment_discount_percentage: Field::Number,
    product_images: NestedHasManyField.with_options(
      nested_edit_attributes: [:image, :alt_text, :sort_order, :is_primary],
      nested_show_attributes: [:image, :alt_text, :sort_order, :is_primary]
    ),
    product_descriptions: Field::HasMany,
    product_specifications: Field::HasMany,
    product_variants: Field::HasMany,
    order_items: Field::HasMany,
    wishlists: Field::HasMany,
    product_reviews: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    name
    sku
    brand
    category
    price
    stock_quantity
    is_active
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    slug
    sku
    brand
    category
    description
    short_description
    price
    discount_percent
    stock_quantity
    min_stock_alert
    warranty_period
    is_active
    is_essential_accessories
    is_new
    is_hot
    is_preorder
    preorder_quantity
    preorder_end_date
    meta_title
    meta_description
    view_count
    full_payment_transfer
    full_payment_discount_percentage
    partial_advance_payment
    advance_payment_percentage
    advance_payment_discount_percentage
    product_variants
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    slug
    sku
    brand
    category
    description
    short_description
    price
    discount_percent
    stock_quantity
    min_stock_alert
    warranty_period
    is_active
    is_essential_accessories
    is_new
    is_hot
    is_preorder
    preorder_quantity
    preorder_end_date
    meta_title
    meta_description
    full_payment_transfer
    full_payment_discount_percentage
    partial_advance_payment
    advance_payment_percentage
    advance_payment_discount_percentage
    product_variants
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how products are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(product)
  #   "Product ##{product.id}"
  # end
end
