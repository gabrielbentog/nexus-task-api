class CreateTaskDependencies < ActiveRecord::Migration[8.0]
  def change
    create_table :task_dependencies, id: :uuid do |t|
      t.uuid :blocked_task_id, null: false
      t.uuid :blocker_task_id, null: false
      t.string :relation_type, null: false, default: 'blocks'
      t.timestamps
    end
    add_foreign_key :task_dependencies, :tasks, column: :blocked_task_id, validate: false
    add_foreign_key :task_dependencies, :tasks, column: :blocker_task_id, validate: false
    add_index :task_dependencies, [:blocked_task_id, :blocker_task_id], unique: true
  end
end
