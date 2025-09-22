class ProductDetailSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :sku, :short_description,
             :price, :original_price, :discount_percent,
             :weight, :dimensions, :stock_quantity, :min_stock_alert,
             :is_active, :is_essential_accessories, :is_new, :is_hot, :is_preorder,
             :preorder_quantity, :preorder_end_date, :warranty_period,
             :meta_title, :meta_description, :view_count, :related_products,
             # Payment options
             :full_payment_transfer, :full_payment_discount_percentage,
             :partial_advance_payment, :advance_payment_percentage, :advance_payment_discount_percentage

  belongs_to :brand, serializer: BrandSerializer
  belongs_to :category, serializer: CategorySerializer
  has_many :images, serializer: ProductImageSerializer
  has_many :variants, serializer: ProductVariantSerializer
  has_many :specifications, serializer: ProductSpecificationSerializer
  has_many :descriptions, serializer: ProductDescriptionSerializer
  has_many :videos, serializer: ProductVideoSerializer

  def related_products
    return [] unless object.category_id

    # Get related products from the same category, excluding current product
    related = Product.active
                     .where(category_id: object.category_id)
                     .where.not(id: object.id)
                     .includes(:images)
                     .order(created_at: :desc)
                     .limit(3)

    related.map do |product|
      {
        id: product.id,
        name: product.name,
        slug: product.slug,
        price: product.price,
        image: product.images.first&.image_url || '/images/placeholder-product.png'
      }.merge(product.payment_options_attributes)
    end
  end
end