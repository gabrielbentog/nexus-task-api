class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  validates :name, presence: true
  validates :key, presence: true, uniqueness: true
end
