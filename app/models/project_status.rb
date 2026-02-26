class ProjectStatus < ApplicationRecord
  belongs_to :project
  has_many :tasks, foreign_key: 'status_id', dependent: :nullify

  CATEGORIES = %w[TODO IN_PROGRESS DONE].freeze

  validates :name, presence: true, uniqueness: { scope: :project_id }, length: { maximum: 255 }
  validates :order, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  before_save :adjust_other_orders, if: -> { order_changed? && !skip_adjust_orders }
  after_destroy :reorder_after_destroy

  attr_accessor :skip_adjust_orders

  scope :ordered, -> { order(:order) }
  scope :todo, -> { where(category: 'TODO') }
  scope :in_progress, -> { where(category: 'IN_PROGRESS') }
  scope :done, -> { where(category: 'DONE') }

  def done?
    category == 'DONE'
  end

  def todo?
    category == 'TODO'
  end

  def in_progress?
    category == 'IN_PROGRESS'
  end

  private

  def reorder_after_destroy
    # Decrementa o order de todos os status > ao order deletado
    ProjectStatus.where(project_id: project_id)
                 .where('"order" > ?', order)
                 .update_all('"order" = "order" - 1')
  end

  def adjust_other_orders
    return unless project_id.present? && order_exists?

    old_order = order_was
    new_order = order

    # Se for uma criação (não tinha order anterior)
    if old_order.nil?
      # Só incrementa se já existir alguém naquele order
      if ProjectStatus.where(project_id: project_id, order: new_order).where.not(id: id).exists?
        increment_orders(new_order, Float::INFINITY)
      end
    elsif new_order > old_order
      # Movendo para baixo (ex: 2 -> 3): Decrementa quem está no meio
      decrement_orders(old_order + 1, new_order)
    elsif new_order < old_order
      # Movendo para cima (ex: 3 -> 1): Incrementa quem está no meio
      increment_orders(new_order, old_order - 1)
    end
  end

  def increment_orders(start_range, end_range)
    scope_for_reorder(start_range, end_range).update_all('"order" = "order" + 1')
  end

  def decrement_orders(start_range, end_range)
    scope_for_reorder(start_range, end_range).update_all('"order" = "order" - 1')
  end

  def scope_for_reorder(start_range, end_range)
    ProjectStatus.where(project_id: project_id)
                 .where(order: start_range..end_range)
                 .where.not(id: id)
  end

  def order_exists?
    # Verifica se o atributo order realmente mudou ou é novo
    order_changed? || new_record?
  end
end
