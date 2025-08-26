class ProductReview < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :order

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :title, presence: true, if: :comment_present?
  validates :comment, presence: true, if: :title_present?

  scope :approved, -> { where(is_approved: true) }
  scope :verified_purchase, -> { where(is_verified_purchase: true) }

  # Ransack configuration for Active Admin
  def self.ransackable_attributes(auth_object = nil)
    %w[id rating title comment is_approved is_verified_purchase created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product user order]
  end

  private

  def comment_present?
    comment.present?
  end

  def title_present?
    title.present?
  end
end 