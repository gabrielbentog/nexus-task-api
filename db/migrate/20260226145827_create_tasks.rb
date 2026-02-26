class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.uuid :project_id, null: false
      t.uuid :status_id, null: false
      t.string :title, null: false
      t.text :description
      t.string :priority, null: false
      t.uuid :assignee_id
      t.uuid :parent_id
      t.datetime :due_date
      t.integer :display_id, null: false

      t.timestamps
    end

    add_foreign_key :tasks, :projects, validate: false
    add_foreign_key :tasks, :project_statuses, column: :status_id, validate: false
    add_foreign_key :tasks, :users, column: :assignee_id, validate: false
    add_foreign_key :tasks, :tasks, column: :parent_id, validate: false
    add_index :tasks, [:project_id, :display_id], unique: true
    add_index :tasks, :status_id
    add_index :tasks, :assignee_id
    add_index :tasks, :parent_id
  end
end
