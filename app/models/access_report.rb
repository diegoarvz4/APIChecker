class AccessReport < ApplicationRecord
  belongs_to :employee, class_name: 'User'
  validates :entry, presence: true, uniqueness: true
end
