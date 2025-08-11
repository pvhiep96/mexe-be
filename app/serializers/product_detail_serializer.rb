class ProductDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :sku, :description, :short_description,
             :price, :original_price, :discount_percent, :cost_price,
             :weight, :dimensions, :stock_quantity, :min_stock_alert,
             :is_active, :is_featured, :is_new, :is_hot, :is_preorder,
             :preorder_quantity, :preorder_end_date, :warranty_period,
             :meta_title, :meta_description, :view_count

  belongs_to :brand, serializer: BrandSerializer
  belongs_to :category, serializer: CategorySerializer
  has_many :images, serializer: ProductImageSerializer
  has_many :variants, serializer: ProductVariantSerializer
  has_many :specifications, serializer: ProductSpecificationSerializer
end
