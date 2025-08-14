class UserAddressSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :address_line, :city, :district, :ward, :postal_code, :is_default

  def name
    object.full_name
  end

  def address_line
    [object.address_line1, object.address_line2].compact.join(', ')
  end

  def district
    object.state
  end

  def ward
    '' # Placeholder - can be added to migration later if needed
  end
end
