class AccessReport < ApplicationRecord
  belongs_to :employee, class_name: 'User'
  validates :entry, presence: true, uniqueness: { scope: :employee_id }
end
