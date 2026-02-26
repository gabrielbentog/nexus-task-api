class Api::TagsController < Api::ApiController
  before_action :set_project
  before_action :set_tag, only: [:update, :destroy]
  before_action :check_member_permission, only: [:index]
  before_action :check_admin_permission, only: [:create, :update, :destroy]

  def index
    tags = @project.tags.order(:name)
    render json: tags, each_serializer: TagSerializer
  end

  def create
    tag = @project.tags.new(tag_params)
    if tag.save
      render json: tag, serializer: TagSerializer, status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      render json: @tag, serializer: TagSerializer
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_api_user.member_projects.find(params[:project_id])
  end

  def set_tag
    @tag = @project.tags.find(params[:id])
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
      render json: { error: 'Você não tem permissão para gerenciar tags deste projeto' }, status: :forbidden
    end
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
