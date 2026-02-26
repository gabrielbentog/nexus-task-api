class CreateSprints < ActiveRecord::Migration[8.0]
  def change
    create_table :sprints, id: :uuid do |t|
      t.uuid :project_id, null: false
      t.string :name, null: false
      t.text :goal
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :status, null: false, default: 'PLANNED'
      t.integer :velocity
      t.timestamps
    end
    add_foreign_key :sprints, :projects, validate: false
    add_index :sprints, [:project_id, :start_date, :end_date]
  end
end
