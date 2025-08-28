class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :phone, :avatar, :date_of_birth, :address, :created_at, :updated_at

  def name
    object.full_name || object.name || 'Unknown User'
  end
  
  def phone
    object.phone || ''
  end
  
  def avatar
    object.avatar || ''
  end
  
  def date_of_birth
    object.date_of_birth&.strftime('%Y-%m-%d') || ''
  end
  
  def address
    object.address || ''
  end
end