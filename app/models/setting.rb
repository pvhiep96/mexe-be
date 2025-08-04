class Setting < ApplicationRecord
  validates :setting_key, presence: true, uniqueness: true

  scope :by_key, ->(key) { where(setting_key: key) }
end 