class ValidateProjectMembersForeignKeys < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :project_members, :projects
    validate_foreign_key :project_members, :users
  end
end
