class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :sku, :short_description,
  :price, :original_price, :discount_percent,
  :weight, :dimensions, :stock_quantity, :min_stock_alert,
  :is_active, :is_essential_accessories, :is_best_seller, :is_new, :is_hot, :is_preorder,
  :is_trending, :is_ending_soon, :is_arriving_soon,
  :preorder_quantity, :preorder_end_date, :warranty_period,
  :meta_title, :meta_description, :view_count, :primary_image_url,
  # Payment options
  :full_payment_transfer, :full_payment_discount_percentage,
  :partial_advance_payment, :advance_payment_percentage, :advance_payment_discount_percentage

  belongs_to :brand, serializer: BrandSerializer
  belongs_to :category, serializer: CategorySerializer
  has_many :images, serializer: ProductImageSerializer
  has_many :variants, serializer: ProductVariantSerializer
  has_many :specifications, serializer: ProductSpecificationSerializer
end
