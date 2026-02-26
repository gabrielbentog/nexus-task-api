class ProjectSerializer < BaseSerializer
  attributes :id, :name, :key, :description, :created_at, :updated_at

  def owner
    {
      id: object.owner.id,
      name: object.owner.name,
      email: object.owner.email
    }
  end
end
