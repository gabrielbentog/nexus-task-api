class TaskDependencySerializer < BaseSerializer
  attributes :id, :blocked_task_id, :blocker_task_id, :relation_type, :created_at, :updated_at
end
