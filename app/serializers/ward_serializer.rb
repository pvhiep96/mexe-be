class WardSerializer < ActiveModel::Serializer
  attributes :code, :name, :full_name, :name_en, :full_name_en, :code_name, :province_code,
             :administrative_unit_name, :province_name, :display_name

  def administrative_unit_name
    object.administrative_unit&.full_name
  end

  def province_name
    object.province&.name
  end

  def display_name
    object.full_name
  end
end