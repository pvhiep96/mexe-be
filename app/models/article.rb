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

  def self.ransackable_attributes(auth_object = nil)
    %w[id title slug excerpt content featured_image author category tags status published_at view_count meta_title meta_description created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[article_images]
  end
end