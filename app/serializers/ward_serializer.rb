class WardSerializer
  include JSONAPI::Serializer

  attributes :code, :name, :full_name, :name_en, :full_name_en, :code_name, :province_code

  attribute :administrative_unit_name do |object|
    object.administrative_unit&.full_name
  end

  attribute :province_name do |object|
    object.province&.name
  end

  attribute :display_name do |object|
    object.full_name
  end
end