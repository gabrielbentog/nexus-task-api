class TaskSerializer < BaseSerializer
  attributes :id, :code, :display_id, :title, :description, :priority, :due_date, :created_at, :updated_at, :subtasks_count, :type, :sprint_id, :points, :start_date, :end_date

  has_many :tags, serializer: TagSerializer

  belongs_to :status, serializer: ProjectStatusSerializer
  belongs_to :assignee, serializer: UserSerializer, optional: true
  belongs_to :parent, serializer: TaskSerializer, optional: true

  def code
    object.code
  end
end
