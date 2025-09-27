class Province < ApplicationRecord
  self.table_name = 'provinces'
  self.primary_key = 'code'
  
  belongs_to :administrative_unit, foreign_key: 'administrative_unit_id'
  has_many :wards, foreign_key: 'province_code', primary_key: 'code', dependent: :destroy
  
  validates :code, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :name_en, presence: true, length: { maximum: 255 }
  validates :full_name, presence: true, length: { maximum: 255 }
  validates :full_name_en, presence: true, length: { maximum: 255 }
  validates :code_name, presence: true, length: { maximum: 255 }
  validates :administrative_unit_id, presence: true
  
  scope :by_name, ->(name) { where(name: name) }
  scope :by_code_name, ->(code_name) { where(code_name: code_name) }
  scope :municipalities, -> { joins(:administrative_unit).where(administrative_units: { id: 1 }) }
  scope :provinces_only, -> { joins(:administrative_unit).where(administrative_units: { id: 2 }) }
  
  def is_municipality?
    administrative_unit_id == 1
  end
  
  def is_province?
    administrative_unit_id == 2
  end
  
  def wards_count
    wards.count
  end
  
  def to_s
    name
  end
end
