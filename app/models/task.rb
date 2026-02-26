class Task < ApplicationRecord
  include Filterable

  belongs_to :project
  belongs_to :status, class_name: 'ProjectStatus', foreign_key: 'status_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  belongs_to :parent, class_name: 'Task', foreign_key: 'parent_id', optional: true, counter_cache: :subtasks_count
  has_many :subtasks, class_name: 'Task', foreign_key: 'parent_id', dependent: :nullify
  has_many :task_tags, dependent: :destroy
  has_many :tags, through: :task_tags
  belongs_to :sprint, optional: true

  has_many :blocked_dependencies, class_name: 'TaskDependency', foreign_key: :blocked_task_id, dependent: :destroy
  has_many :blocker_dependencies, class_name: 'TaskDependency', foreign_key: :blocker_task_id, dependent: :destroy
  has_many :blockers, through: :blocked_dependencies, source: :blocker_task
  has_many :blocked_tasks, through: :blocker_dependencies, source: :blocked_task

  PRIORITIES = %w[LOW MEDIUM HIGH URGENT].freeze
  TYPES = %w[TASK EPIC].freeze

  validates :title, presence: true
  validates :priority, presence: true, inclusion: { in: PRIORITIES }
  validates :display_id, presence: true, uniqueness: { scope: :project_id }
  validates :type, presence: true, inclusion: { in: TYPES }
  validates :points, numericality: { only_integer: true, allow_nil: true }

  before_validation :set_display_id, on: :create
  before_validation :set_default_status, on: :create
  before_validation :set_default_type, on: :create

  def code
    return unless project && display_id
    "#{project.key}-#{display_id}"
  end

  private

  def set_display_id
    return if display_id.present?
    max = Task.where(project_id: project_id).maximum(:display_id)
    self.display_id = max ? max + 1 : 1
  end

  def set_default_status
    return if status_id.present?
    self.status = project.project_statuses.ordered.first if project
  end

  def set_default_type
    self.type ||= 'TASK'
  end
end
