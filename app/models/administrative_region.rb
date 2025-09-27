class AdministrativeRegion < ApplicationRecord
  self.table_name = 'administrative_regions'
  
  validates :name, presence: true, length: { maximum: 255 }
  validates :name_en, presence: true, length: { maximum: 255 }
  validates :code_name, presence: true, length: { maximum: 255 }
  validates :code_name_en, presence: true, length: { maximum: 255 }
  
  # No direct relationship with provinces due to v3.0.0 changes
  # but we can still get provinces in this region if needed
  
  scope :by_name, ->(name) { where(name: name) }
  scope :by_code_name, ->(code_name) { where(code_name: code_name) }
end
