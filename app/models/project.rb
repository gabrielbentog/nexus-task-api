class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user

  validates :name, presence: true
  validates :key, presence: true, uniqueness: true

  after_create :add_owner_as_admin_member

  private

  def add_owner_as_admin_member
    project_members.create!(
      user_id: owner_id,
      role: 'admin'
    )
  end
end
