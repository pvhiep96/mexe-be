# app/serializers/user_serializer.rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :phone, :avatar, :date_of_birth,
             :gender, :is_active, :is_verified, :email_verified_at,
             :phone_verified_at, :last_login_at

  has_many :addresses, serializer: UserAddressSerializer
end
