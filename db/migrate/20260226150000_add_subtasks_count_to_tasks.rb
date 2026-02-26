class AddSubtasksCountToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :subtasks_count, :integer, null: false, default: 0
  end
end
