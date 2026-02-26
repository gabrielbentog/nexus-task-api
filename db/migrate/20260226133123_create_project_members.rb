class CreateProjectMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :project_members, id: false do |t|
      t.uuid :project_id, null: false
      t.uuid :user_id, null: false
      t.string :role, null: false
      t.datetime :joined_at, null: false

      t.timestamps
    end

    # Chave primária composta
    safety_assured do
      execute "ALTER TABLE project_members ADD PRIMARY KEY (project_id, user_id);"
    end

    add_foreign_key :project_members, :projects, validate: false
    add_foreign_key :project_members, :users, validate: false
    add_index :project_members, :project_id
    add_index :project_members, :user_id
  end
end
