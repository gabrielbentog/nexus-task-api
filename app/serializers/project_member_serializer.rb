class ProjectMemberSerializer < BaseSerializer
  attributes :project_id, :user_id, :role, :joined_at

  belongs_to :user

  def user
    {
      id: object.user.id,
      name: object.user.name,
      email: object.user.email,
      avatar: object.user.avatar.attached? ? Rails.application.routes.url_helpers.rails_blob_url(object.user.avatar, only_path: true) : nil
    }
  end
end
