class CreateTaskTags < ActiveRecord::Migration[8.0]
  def change
    create_table :task_tags, id: false do |t|
      t.uuid :task_id, null: false
      t.uuid :tag_id, null: false
      t.timestamps
    end
    add_foreign_key :task_tags, :tasks, validate: false
    add_foreign_key :task_tags, :tags, validate: false
    add_index :task_tags, [:task_id, :tag_id], unique: true
  end
end
