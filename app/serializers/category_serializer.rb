class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :description, :sort_order, :is_active

  has_many :subcategories, serializer: CategorySerializer
  belongs_to :parent, serializer: CategorySerializer, if: -> { object.parent.present? }
end
