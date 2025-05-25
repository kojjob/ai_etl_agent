class CreateDashboards < ActiveRecord::Migration[8.0]
  def change
    create_table :dashboards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.jsonb :layout_config
      t.boolean :is_default
      t.boolean :is_shared
      t.jsonb :shared_with_roles

      t.timestamps
    end
  end
end
