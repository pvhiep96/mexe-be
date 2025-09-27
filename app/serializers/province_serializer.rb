class ProvinceSerializer
  include JSONAPI::Serializer
  
  attributes :code, :name, :name_en, :full_name, :full_name_en, :code_name
  
  attribute :type do |province|
    province.administrative_unit&.short_name
  end
  
  attribute :type_en do |province|
    province.administrative_unit&.short_name_en
  end
  
  attribute :is_municipality do |province|
    province.is_municipality?
  end
  
  attribute :wards_count do |province|
    province.wards.count
  end
end