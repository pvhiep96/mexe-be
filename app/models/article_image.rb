class ArticleImage < ApplicationRecord
  belongs_to :article

  validates :image_url, presence: true

  scope :ordered, -> { order(sort_order: :asc) }
end 