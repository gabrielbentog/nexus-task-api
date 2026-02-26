class CreateProjectStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :project_statuses, id: :uuid do |t|
      t.uuid :project_id, null: false
      t.string :name, null: false
      t.integer :order, null: false, default: 0
      t.string :category, null: false

      t.timestamps
    end

    add_foreign_key :project_statuses, :projects, validate: false
    add_index :project_statuses, :project_id
  end
end
