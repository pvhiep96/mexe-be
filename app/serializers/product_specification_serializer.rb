class ProductSpecificationSerializer < ActiveModel::Serializer
  attributes :id, :spec_name, :spec_value, :sort_order
end
