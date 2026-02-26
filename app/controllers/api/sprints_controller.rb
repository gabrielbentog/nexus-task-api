class Api::SprintsController < Api::ApiController
  before_action :set_project
  before_action :set_sprint, only: [:show, :update, :destroy]
  before_action :check_member_permission, only: [:index, :show]
  before_action :check_admin_permission, only: [:create, :update, :destroy]

  def index
    sprints = @project.sprints.order(:start_date)
    render json: sprints, each_serializer: SprintSerializer
  end

  def show
    render json: @sprint, serializer: SprintSerializer
  end

  def create
    sprint = @project.sprints.new(sprint_params)
    if sprint.save
      render json: sprint, serializer: SprintSerializer, status: :created
    else
      render json: { errors: sprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @sprint.update(sprint_params)
      render json: @sprint, serializer: SprintSerializer
    else
      render json: { errors: @sprint.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @sprint.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_api_user.member_projects.find(params[:project_id])
  end

  def set_sprint
    @sprint = @project.sprints.find(params[:id])
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
      render json: { error: 'Você não tem permissão para gerenciar sprints deste projeto' }, status: :forbidden
    end
  end

  def sprint_params
    params.require(:sprint).permit(:name, :goal, :start_date, :end_date, :status, :velocity)
  end
end
