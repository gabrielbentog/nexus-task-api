class Api::ProjectMembersController < Api::ApiController
  before_action :set_project
  before_action :check_admin_permission, only: [:create, :update, :destroy]
  before_action :set_project_member, only: [:update, :destroy]

  # GET /api/projects/:project_id/members
  def index
    members = @project.project_members.includes(:user).order(joined_at: :asc)
    render json: members, each_serializer: ProjectMemberSerializer, status: :ok
  end

  def create
    member = @project.project_members.new(project_member_params)

    if member.save
      render json: member, serializer: ProjectMemberSerializer, status: :created
    else
      render json: { errors: member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @project_member.update(project_member_params)
      render json: @project_member, serializer: ProjectMemberSerializer
    else
      render json: { errors: @project_member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @project_member.destroy
    head :no_content
  end

  private

  def set_project
    @project = current_api_user.projects.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    # Verifica se o usuário é membro do projeto
    @project = Project.joins(:project_members)
                     .where(project_members: { user_id: current_api_user.id })
                     .find(params[:project_id])
  end

  def set_project_member
    @project_member = @project.project_members.find_by!(
      project_id: params[:project_id],
      user_id: params[:id]
    )
  end

  def check_admin_permission
    member = @project.project_members.find_by(user_id: current_api_user.id)
    is_owner = @project.owner_id == current_api_user.id

    unless is_owner || (member&.role == 'admin')
      render json: { error: 'Você não tem permissão para realizar esta ação' }, status: :forbidden
    end
  end

  def project_member_params
    params.require(:project_member).permit(:user_id, :role)
  end
end
