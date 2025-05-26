class FixUserRoleConstraints < ActiveRecord::Migration[8.0]
  def change
    # Make the polymorphic role reference optional since we're using the simple enum approach
    change_column_null :users, :role_type, true
    change_column_null :users, :role_id, true
  end
end
