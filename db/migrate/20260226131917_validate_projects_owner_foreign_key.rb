class ValidateProjectsOwnerForeignKey < ActiveRecord::Migration[8.0]
  def change
    validate_foreign_key :projects, :users, column: :owner_id
  end
end
