class Api::ProjectsController < Api::ApiController
  before_action :set_project, only: [:show, :update, :destroy]
  before_action :check_admin_permission, only: [:update]
  before_action :check_owner_permission, only: [:destroy]

  def index
    projects = current_api_user.member_projects.order(created_at: :desc)
    render json: projects, each_serializer: ProjectSerializer, status: :ok
  end

  def show
    render json: @project, serializer: ProjectSerializer
  end

  def create
    project = current_api_user.projects.new(project_params)

    if project.save
      render json: project, serializer: ProjectSerializer, status: :created
    else
      render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project, serializer: ProjectSerializer
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_api_user.member_projects.find(params[:id])
  end

  def check_admin_permission
    member = @project.project_members.find_by(user_id: current_api_user.id)
    is_owner = @project.owner_id == current_api_user.id

    unless is_owner || member&.role == 'admin'
      render json: { error: 'Você não tem permissão para editar este projeto' }, status: :forbidden
    end
  end

  def check_owner_permission
    unless @project.owner_id == current_api_user.id
      render json: { error: 'Apenas o dono pode deletar este projeto' }, status: :forbidden
    end
  end

  def project_params
    params.require(:project).permit(:name, :key, :description)
  end
end
