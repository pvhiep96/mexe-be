class Article < ApplicationRecord
  has_many :article_images, dependent: :destroy

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  enum status: {
    draft: 'draft',
    published: 'published',
    archived: 'archived'
  }

  scope :published, -> { where(status: 'published') }
  scope :active, -> { where.not(status: 'archived') }
end 