# db/migrate/20250525143123_create_projects.rb (or similar timestamp)
class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false, index: { unique: true } # Ensures project names are unique

      t.references :created_by_user, foreign_key: { to_table: :users }, null: false # Ensures every project has a creator

      t.string :status, default: "active", null: false
      t.datetime :started_at
      t.datetime :due_at
      t.jsonb :tags, default: []

      t.timestamps 

 
    end
    # Only add indexes for columns not already handled by `index: { unique: true }` or `t.references`
    add_index :projects, :status
    add_index :projects, :started_at
    add_index :projects, :due_at
    add_index :projects, :tags, using: :gin # For jsonb querying, GIN index is correct.

  end
end