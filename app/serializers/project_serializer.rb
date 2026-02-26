
class ProjectSerializer < BaseSerializer
  attributes :id, :name, :key, :description, :created_at, :updated_at
  has_many :tags, serializer: TagSerializer

  def owner
    {
      id: object.owner.id,
      name: object.owner.name,
      email: object.owner.email
    }
  end
end
