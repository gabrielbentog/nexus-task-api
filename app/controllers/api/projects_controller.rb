class Api::ProjectsController < Api::ApiController
  before_action :set_project, only: [:show, :update, :destroy]

  def index
    projects = current_api_user.projects.order(created_at: :desc)
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
    @project = current_api_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :key, :description)
  end
end
