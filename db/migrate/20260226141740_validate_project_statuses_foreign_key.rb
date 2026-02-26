class ValidateProjectStatusesForeignKey < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :project_statuses, :projects
  end
end
