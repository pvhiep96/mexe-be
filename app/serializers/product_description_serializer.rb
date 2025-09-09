class ProductDescriptionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :sort_order
end