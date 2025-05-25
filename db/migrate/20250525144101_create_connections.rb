class CreateConnections < ActiveRecord::Migration[8.0]
  def change
    create_table :connections do |t|
      t.string :name
      t.text :description
      t.string :type
      t.jsonb :configuration
      t.string :test_status
      t.datetime :last_tested_at
      t.references :created_by_user, null: false, foreign_key: { to_table: :users }, null: false 

      t.timestamps
    end
    add_index :connections, :name, unique: true
  end
end
