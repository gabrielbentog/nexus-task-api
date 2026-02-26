class SprintSerializer < BaseSerializer
  attributes :id, :project_id, :name, :goal, :start_date, :end_date, :status, :velocity, :created_at, :updated_at
end
