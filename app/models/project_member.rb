class ProjectMember < ApplicationRecord
  self.primary_key = [:project_id, :user_id]

  belongs_to :project
  belongs_to :user

  ROLES = %w[admin member viewer].freeze

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :joined_at, presence: true
  validates :user_id, uniqueness: { scope: :project_id }

  before_validation :set_joined_at, on: :create

  private

  def set_joined_at
    self.joined_at ||= Time.current
  end
end
