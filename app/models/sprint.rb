class Sprint < ApplicationRecord
  belongs_to :project
  has_many :tasks, dependent: :nullify

  STATUSES = %w[PLANNED ACTIVE COMPLETED].freeze

  validates :name, presence: true
  validates :start_date, :end_date, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
