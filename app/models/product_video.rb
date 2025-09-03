class ProductVideo < ApplicationRecord
  belongs_to :product
  
  validates :url, presence: true, format: { 
    with: /\A(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be|vimeo\.com)\/.+/i,
    message: "must be a valid YouTube or Vimeo URL" 
  }
  validates :title, presence: true
  validates :sort_order, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(is_active: true) }
  scope :ordered, -> { order(sort_order: :asc) }

  # Extract YouTube video ID from URL
  def youtube_video_id
    return nil unless url.present?
    
    # Handle different YouTube URL formats
    patterns = [
      /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})/,
      /youtube\.com\/v\/([a-zA-Z0-9_-]{11})/
    ]
    
    patterns.each do |pattern|
      match = url.match(pattern)
      return match[1] if match
    end
    
    nil
  end

  # Get YouTube embed URL
  def embed_url
    video_id = youtube_video_id
    return nil unless video_id
    "https://www.youtube.com/embed/#{video_id}"
  end

  # Get YouTube thumbnail URL
  def thumbnail_url
    video_id = youtube_video_id
    return nil unless video_id
    "https://img.youtube.com/vi/#{video_id}/maxresdefault.jpg"
  end

  # Check if URL is YouTube
  def youtube?
    url.present? && url.match?(/youtube\.com|youtu\.be/i)
  end

  # Check if URL is Vimeo
  def vimeo?
    url.present? && url.match?(/vimeo\.com/i)
  end
end