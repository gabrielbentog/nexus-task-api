class TaskDependency < ApplicationRecord
  belongs_to :blocked_task, class_name: 'Task'
  belongs_to :blocker_task, class_name: 'Task'

  RELATION_TYPES = %w[blocks requires relates_to].freeze

  validates :blocked_task_id, :blocker_task_id, presence: true
  validates :relation_type, presence: true, inclusion: { in: RELATION_TYPES }
  validates :blocked_task_id, uniqueness: { scope: :blocker_task_id }
end
