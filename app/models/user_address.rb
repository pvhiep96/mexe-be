class UserAddress < ApplicationRecord
  belongs_to :user
  belongs_to :province, foreign_key: 'province_code', primary_key: 'code', optional: true
  belongs_to :ward, foreign_key: 'ward_code', primary_key: 'code', optional: true

  validates :full_name, presence: true
  validates :phone, presence: true
  validates :address_line1, presence: true

  # Thay đổi từ city thành province_code và ward_code
  validates :province_code, presence: true
  validates :ward_code, presence: true

  # Scope để lấy địa chỉ theo tỉnh/thành phố
  scope :by_province, ->(province_code) { where(province_code: province_code) }
  scope :by_ward, ->(ward_code) { where(ward_code: ward_code) }

  def full_address
    address_parts = [address_line1]
    address_parts << ward.full_name if ward.present?
    address_parts << province.full_name if province.present?
    address_parts.compact.join(', ')
  end

  def province_name
    province&.name
  end

  def ward_name
    ward&.name
  end
end 