class CreateAlerts < ActiveRecord::Migration[8.0]
  def change
    create_table :alerts do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.references :pipeline_run, null: false, foreign_key: true
      t.references :pipeline_step_run, null: false, foreign_key: true
      t.references :alert_rule, null: false, foreign_key: true
      t.string :severity
      t.text :message
      t.string :status
      t.references :acknowledged_by_user, null: true, foreign_key: { to_table: :users }
      t.datetime :acknowledged_at
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
