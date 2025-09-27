class ProvinceSerializer < ActiveModel::Serializer
  attributes :code, :name, :name_en, :full_name, :full_name_en, :code_name,
             :type, :type_en, :is_municipality, :wards_count

  def type
    object.administrative_unit&.short_name
  end

  def type_en
    object.administrative_unit&.short_name_en
  end

  def is_municipality
    object.is_municipality?
  end

  def wards_count
    object.wards.count
  end
end