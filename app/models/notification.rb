class Notification < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :message, presence: true
  validates :type, presence: true

  scope :unread, -> { where(is_read: false) }
  scope :read, -> { where(is_read: true) }
end 