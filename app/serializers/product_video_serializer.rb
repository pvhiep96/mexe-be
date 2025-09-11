class ProductVideoSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :description, :sort_order, :is_active, :embed_url, :thumbnail_url, :youtube_video_id

  def embed_url
    object.embed_url
  end

  def thumbnail_url
    object.thumbnail_url
  end

  def youtube_video_id
    object.youtube_video_id
  end
end
