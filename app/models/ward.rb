class Ward < ApplicationRecord
  self.table_name = 'wards'
  self.primary_key = 'code'
  
  belongs_to :province, foreign_key: 'province_code', primary_key: 'code'
  belongs_to :administrative_unit, foreign_key: 'administrative_unit_id'
  
  validates :code, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :name_en, presence: true, length: { maximum: 255 }
  validates :full_name, presence: true, length: { maximum: 255 }
  validates :full_name_en, presence: true, length: { maximum: 255 }
  validates :code_name, presence: true, length: { maximum: 255 }
  validates :province_code, presence: true, length: { maximum: 20 }
  validates :administrative_unit_id, presence: true
  
  scope :by_province, ->(province_code) { where(province_code: province_code) }
  scope :by_name, ->(name) { where(name: name) }
  scope :by_code_name, ->(code_name) { where(code_name: code_name) }
  scope :wards_only, -> { joins(:administrative_unit).where(administrative_units: { id: 3 }) }
  scope :communes, -> { joins(:administrative_unit).where(administrative_units: { id: 4 }) }
  scope :special_regions, -> { joins(:administrative_unit).where(administrative_units: { id: 5 }) }
  
  def is_ward?
    administrative_unit_id == 3
  end
  
  def is_commune?
    administrative_unit_id == 4
  end
  
  def is_special_region?
    administrative_unit_id == 5
  end
  
  def province_name
    province&.name
  end
  
  def full_address
    "#{full_name}, #{province&.full_name}"
  end
  
  def to_s
    name
  end
end
