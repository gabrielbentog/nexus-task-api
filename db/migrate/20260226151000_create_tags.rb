class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.uuid :project_id, null: false
      t.string :name, null: false
      t.string :color, null: false
      t.timestamps
    end
    add_foreign_key :tags, :projects, validate: false
    add_index :tags, [:project_id, :name], unique: true
  end
end
