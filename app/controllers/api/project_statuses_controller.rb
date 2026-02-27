class Api::ProjectStatusesController < Api::ApiController
  before_action :set_project
  before_action :check_admin_permission, only: [:create, :update, :destroy]
  before_action :set_project_status, only: [:update, :destroy, :reorder, :move_tasks, :clear]

  # GET /api/projects/:project_id/statuses
  def index
    statuses = @project.project_statuses.ordered
    render json: statuses, each_serializer: ProjectStatusSerializer, status: :ok
  end

  def create
    status = @project.project_statuses.new(project_status_params)

    if status.save
      render json: status, serializer: ProjectStatusSerializer, status: :created
    else
      render json: { errors: status.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @project_status.update(project_status_params)
      render json: @project_status, serializer: ProjectStatusSerializer
    else
      render json: { errors: @project_status.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/projects/:project_id/statuses/:id/reorder
  def reorder
    position = params.require(:position)
    if @project_status.update(order: position)
      render json: @project_status, serializer: ProjectStatusSerializer
    else
      render json: { errors: @project_status.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/projects/:project_id/statuses/:id/move_tasks
  def move_tasks
    target_id = params.require(:targetColumnId)
    target = @project.project_statuses.find(target_id)
    @project_status.tasks.update_all(status_id: target.id)
    head :no_content
  end

  # DELETE /api/projects/:project_id/statuses/:id/clear
  def clear
    # remove all tasks assigned to this status
    @project_status.tasks.destroy_all
    head :no_content
  end

  def destroy
    @project_status.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_api_user.member_projects.find(params[:project_id])
  end

  def set_project_status
    @project_status = @project.project_statuses.find(params[:id])
  end

  def check_admin_permission
    member = @project.project_members.find_by(user_id: current_api_user.id)
    is_owner = @project.owner_id == current_api_user.id

    unless is_owner || member&.role == 'admin'
      render json: { error: 'Você não tem permissão para gerenciar status deste projeto' }, status: :forbidden
    end
  end

  def project_status_params
    params.require(:project_status).permit(:name, :order, :category)
  end
end
