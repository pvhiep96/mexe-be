class ProductReview < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :order

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :title, presence: true, if: :comment_present?
  validates :comment, presence: true, if: :title_present?

  scope :approved, -> { where(is_approved: true) }
  scope :verified_purchase, -> { where(is_verified_purchase: true) }

  private

  def comment_present?
    comment.present?
  end

  def title_present?
    title.present?
  end
end 