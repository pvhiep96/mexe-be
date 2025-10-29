require "administrate/base_dashboard"

class ProductVariantDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    product: Field::BelongsTo,
    variant_name: Field::String,
    variant_value: Field::String,
    price_adjustment: Field::Number.with_options(decimals: 2),
    stock_quantity: Field::Number,
    sku: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  COLLECTION_ATTRIBUTES = %i[
    id
    product
    variant_name
    variant_value
    price_adjustment
    stock_quantity
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    product
    variant_name
    variant_value
    price_adjustment
    stock_quantity
    sku
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  # Note: 'product' is excluded for nested forms
  FORM_ATTRIBUTES = %i[
    variant_name
    variant_value
    price_adjustment
    stock_quantity
    sku
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how product variants are displayed
  # across all pages of the admin dashboard.
  def display_resource(product_variant)
    "#{product_variant.variant_name}: #{product_variant.variant_value}"
  end
end
