class AdministrativeUnit < ApplicationRecord
  self.table_name = 'administrative_units'
  
  has_many :provinces, foreign_key: 'administrative_unit_id', dependent: :restrict_with_error
  has_many :wards, foreign_key: 'administrative_unit_id', dependent: :restrict_with_error
  
  validates :full_name, presence: true, length: { maximum: 255 }
  validates :full_name_en, presence: true, length: { maximum: 255 }
  validates :short_name, presence: true, length: { maximum: 255 }
  validates :short_name_en, presence: true, length: { maximum: 255 }
  validates :code_name, presence: true, length: { maximum: 255 }
  validates :code_name_en, presence: true, length: { maximum: 255 }
  
  scope :by_type, ->(type) { where(code_name: type) }
  scope :municipalities, -> { where(id: 1) } # Thành phố trực thuộc trung ương
  scope :provinces_only, -> { where(id: 2) } # Tỉnh
  scope :wards_only, -> { where(id: 3) } # Phường
  scope :communes, -> { where(id: 4) } # Xã
  scope :special_regions, -> { where(id: 5) } # Đặc khu
end
