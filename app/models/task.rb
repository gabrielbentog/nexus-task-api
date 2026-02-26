
class Task < ApplicationRecord
  include Filterable

  belongs_to :project
  belongs_to :status, class_name: 'ProjectStatus', foreign_key: 'status_id'
  belongs_to :assignee, class_name: 'User', foreign_key: 'assignee_id', optional: true
  belongs_to :parent, class_name: 'Task', foreign_key: 'parent_id', optional: true, counter_cache: :subtasks_count
  has_many :subtasks, class_name: 'Task', foreign_key: 'parent_id', dependent: :nullify

  PRIORITIES = %w[LOW MEDIUM HIGH URGENT].freeze

  validates :title, presence: true
  validates :priority, presence: true, inclusion: { in: PRIORITIES }
  validates :display_id, presence: true, uniqueness: { scope: :project_id }

  before_validation :set_display_id, on: :create

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
end
