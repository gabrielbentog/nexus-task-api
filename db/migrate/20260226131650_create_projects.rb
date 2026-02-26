class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.string :key, null: false
      t.text :description
      t.uuid :owner_id, null: false

      t.timestamps
    end

    add_index :projects, :key, unique: true
    add_foreign_key :projects, :users, column: :owner_id, validate: false
  end
end
