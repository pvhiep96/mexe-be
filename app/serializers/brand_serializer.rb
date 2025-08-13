class BrandSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug, :logo
end
