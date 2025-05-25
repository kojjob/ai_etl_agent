class AddDetailsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    add_column :users, :full_name, :string
    add_column :users, :is_active, :boolean
    add_column :users, :is_admin, :boolean
    add_reference :users, :role, polymorphic: true, null: false

    add_index :users, :username, unique: true
    add_index :users, :full_name
    add_index :users, :is_active
    add_index :users, :is_admin
  end
end
