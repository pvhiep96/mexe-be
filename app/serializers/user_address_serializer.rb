class UserAddressSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :phone, :address_line1, :address_line2,
             :city, :state, :postal_code, :country, :is_default, :is_active
end
