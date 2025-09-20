class Product < ApplicationRecord
  include PaymentOptionsSerializable

  belongs_to :brand, optional: true
  belongs_to :category, optional: true
  belongs_to :client, class_name: 'AdminUser', optional: true
  has_many :product_images, dependent: :destroy
  has_many :product_descriptions, dependent: :destroy
  has_many :product_specifications, dependent: :destroy
  has_many :product_videos, dependent: :destroy
  has_many :product_variants, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :wished_by_users, through: :wishlists, source: :user
  has_many :product_reviews, dependent: :destroy
  has_many :product_approvals, dependent: :destroy
  has_many :images, class_name: 'ProductImage'
  has_many :descriptions, class_name: 'ProductDescription'
  has_many :videos, class_name: 'ProductVideo'
  has_many :variants, class_name: 'ProductVariant'
  has_many :specifications, class_name: 'ProductSpecification'

  # Nested attributes for admin interface
  accepts_nested_attributes_for :product_images, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :product_descriptions, allow_destroy: true, reject_if: proc { |attr| attr['title'].blank? && attr['content'].blank? }
  accepts_nested_attributes_for :product_specifications, allow_destroy: true, reject_if: proc { |attr| attr['spec_name'].blank? && attr['spec_value'].blank? }
  accepts_nested_attributes_for :product_videos, allow_destroy: true, reject_if: proc { |attr| attr['url'].blank? && attr['title'].blank? }

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }

  # Payment option validations
  validates :advance_payment_percentage,
    numericality: { greater_than: 0, less_than_or_equal_to: 100 },
    if: :partial_advance_payment?
  validates :full_payment_discount_percentage,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
    allow_blank: true
  validates :advance_payment_discount_percentage,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
    allow_blank: true

  # Custom validation for Status & Flags fields - only Super Admin can edit
  validate :can_update_status_flags?, if: :status_flags_changed?
  
  # Product approval workflow
  before_save :set_client_if_needed
  after_create :create_approval_request, if: :created_by_client?
  after_update :create_edit_approval_request, if: :should_create_edit_approval?

  scope :active, -> { where(is_active: true) }
  scope :essential_accessories, -> { where(is_essential_accessories: true) }
  scope :new_products, -> { where(is_new: true) }
  scope :hot_products, -> { where(is_hot: true) }
  scope :preorder, -> { where(is_preorder: true) }
  scope :filter_by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :filter_by_brand, ->(brand_id) { where(brand_id: brand_id) if brand_id.present? }
  scope :search_by_query, ->(query) {
    return all if query.blank?
    
    search_term = "%#{sanitize_sql_like(query)}%"
    joins("LEFT JOIN brands ON products.brand_id = brands.id")
      .where(
        "products.name LIKE ? OR products.description LIKE ? OR products.short_description LIKE ? OR brands.name LIKE ?",
        search_term, search_term, search_term, search_term
      )
  }


  # Get primary image or first image
  def primary_image
    product_images.primary.first || product_images.first
  end

  # Get primary image URL
  def primary_image_url
    return nil unless primary_image&.image_url.present?
    primary_image.image_url
  end

  # Check if product has pending approval
  def has_pending_approval?
    product_approvals.pending.exists?
  end

  # Get latest approval status
  def latest_approval
    product_approvals.order(created_at: :desc).first
  end

  # Check if product needs approval
  def needs_approval?
    !is_active? && created_by_client?
  end

  # Payment option helper methods
  def partial_advance_payment?
    partial_advance_payment == true
  end

  def full_payment_transfer?
    full_payment_transfer == true
  end

  # Calculate actual price after discount for full payment
  def full_payment_price
    return price unless full_payment_transfer? && full_payment_discount_percentage.present?
    price * (1 - full_payment_discount_percentage / 100.0)
  end

  # Calculate advance payment amount
  def advance_payment_amount
    return 0 unless partial_advance_payment? && advance_payment_percentage.present?
    price * (advance_payment_percentage / 100.0)
  end

  # Calculate remaining payment amount after advance
  def remaining_payment_amount
    return price unless partial_advance_payment? && advance_payment_percentage.present?
    advance_amount = advance_payment_amount
    discount = advance_payment_discount_percentage.present? ? (advance_amount * advance_payment_discount_percentage / 100.0) : 0
    (price - advance_amount) + discount
  end

  private

  def status_flags_changed?
    # Check if any Status & Flags fields have changed
    status_flags_fields.any? { |field| send("#{field}_changed?") }
  end

  def status_flags_fields
    %w[is_active is_essential_accessories is_best_seller is_new is_hot is_preorder is_trending is_ending_soon is_arriving_soon]
  end

  def can_update_status_flags?
    # Get current admin user from Thread.current (set by controller)
    current_admin = Thread.current[:current_admin_user]

    # Only Super Admin can edit Status & Flags
    if current_admin.present? && !current_admin.super_admin?
      changed_status_flags = status_flags_fields.select { |field| send("#{field}_changed?") }
      if changed_status_flags.any?
        errors.add(:base, "Chỉ Super Admin mới có quyền chỉnh sửa Status & Flags của sản phẩm")
        changed_status_flags.each do |field|
          errors.add(field, "Chỉ Super Admin mới có quyền chỉnh sửa trường này")
        end
      end
    end
  end

  def created_by_client?
    current_admin = Thread.current[:current_admin_user]
    current_admin&.client? && client_id.present?
  end

  def should_create_edit_approval?
    # Only create edit approval if product was updated by a different user than the client
    # and the client exists and product has significant changes
    current_admin = Thread.current[:current_admin_user]
    return false unless client_id.present?
    return false unless current_admin&.client?
    return false if current_admin.id == client_id
    
    # Check if important fields were changed
    important_fields = %w[name description price stock_quantity brand_id category_id]
    (changed & important_fields).any?
  end

  def create_approval_request
    product_approvals.create(
      status: :pending,
      approval_type: :creation
    )
  end

  def create_edit_approval_request
    product_approvals.create(
      status: :pending,
      approval_type: :edit
    )
  end

  def set_client_if_needed
    current_admin = Thread.current[:current_admin_user]
    if current_admin&.client? && client_id.blank?
      self.client_id = current_admin.id
      # Ensure client-created products are inactive by default
      self.is_active = false
    end
  end
end
