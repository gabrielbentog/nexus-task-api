class ProjectStatusSerializer < BaseSerializer
  attributes :id, :project_id, :name, :order, :category, :created_at, :updated_at

  def category
    object.category
  end
end
