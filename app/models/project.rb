class Project < ApplicationRecord
  include Filterable

  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user
  has_many :project_statuses, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :key, presence: true, uniqueness: true

  after_create :add_owner_as_admin_member
  after_create :create_default_statuses

  private

  def add_owner_as_admin_member
    project_members.create!(
      user_id: owner_id,
      role: 'admin'
    )
  end

  def create_default_statuses
    project_statuses.create!([
      { name: 'A Fazer', order: 0, category: 'TODO', skip_adjust_orders: true },
      { name: 'Em Andamento', order: 1, category: 'IN_PROGRESS', skip_adjust_orders: true },
      { name: 'Validação', order: 2, category: 'IN_PROGRESS', skip_adjust_orders: true },
      { name: 'Concluído', order: 3, category: 'DONE', skip_adjust_orders: true }
    ])
  end
end
