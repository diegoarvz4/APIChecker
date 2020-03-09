class User < ApplicationRecord
  has_secure_password
  has_many :access_reports, foreign_key: 'employee_id'
  validates :name, presence: true, length: { maximum: 50 }
  validates :username, presence: true, uniqueness: true, length: { maximum: 50 }
end
