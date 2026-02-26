class AddEpicFieldsToTasks < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def change
    add_column :tasks, :task_type, :string, null: false, default: 'TASK'
    add_column :tasks, :sprint_id, :uuid
    add_column :tasks, :points, :integer
    add_column :tasks, :start_date, :date
    add_column :tasks, :end_date, :date

    add_foreign_key :tasks, :sprints, validate: false
    add_index :tasks, :sprint_id, algorithm: :concurrently
  end
end
