class CreateDashboardWidgets < ActiveRecord::Migration[8.0]
  def change
    create_table :dashboard_widgets do |t|
      t.references :dashboard, null: false, foreign_key: true
      t.string :widget_type
      t.string :title
      t.jsonb :configuration
      t.integer :refresh_interval_seconds

      t.timestamps
    end
  end
end
