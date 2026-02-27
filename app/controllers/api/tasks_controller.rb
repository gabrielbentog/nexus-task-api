class Api::TasksController < Api::ApiController
  before_action :set_project
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :check_member_permission, only: [:index, :show]
  before_action :check_admin_permission, only: [:create, :update, :destroy]

  # GET /api/projects/:project_id/tasks
  def index
    tasks = @project.tasks.includes(:status, :assignee).order(:display_id)
    tasks = tasks.apply_filters(params)

    meta = generate_meta(tasks)
    render json: tasks, each_serializer: TaskSerializer, meta: meta, status: :ok
  end

  # GET /api/projects/:project_id/tasks/kanban
  def kanban
    statuses = @project.project_statuses.ordered
    result = statuses.map do |status|
      {
        status: ProjectStatusSerializer.new(status).as_json,
        tasks: status.tasks.where.not(task_type: "EPIC", parent_id: nil).order(:display_id).map { |t| TaskSerializer.new(t).as_json }
      }
    end
    render json: { data: result }, status: :ok
  end

  def show
    render json: @task, serializer: TaskSerializer
  end

  def create
    task = @project.tasks.new(task_params)
    if task.save
      render json: task, serializer: TaskSerializer, status: :created
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task, serializer: TaskSerializer
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_api_user.member_projects.find(params[:project_id])
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  end

  def check_member_permission
    unless @project.members.include?(current_api_user) || @project.owner == current_api_user
      render json: { error: 'Você não tem acesso a este projeto' }, status: :forbidden
    end
  end

  def check_admin_permission
    member = @project.project_members.find_by(user_id: current_api_user.id)
    is_owner = @project.owner_id == current_api_user.id
    unless is_owner || member&.role == 'admin'
      render json: { error: 'Você não tem permissão para gerenciar tarefas deste projeto' }, status: :forbidden
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :status_id, :assignee_id, :parent_id, :due_date)
  end
end
