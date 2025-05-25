class CreateSchedules < ActiveRecord::Migration[8.0]
  def change
    create_table :schedules do |t|
      t.references :pipeline, index: {unique: true}, null: false, foreign_key: true
      t.string :cron_expression
      t.string :timezone
      t.boolean :is_active
      t.datetime :next_run_at
      t.references :last_triggered_run, null: true
      t.references :created_by_user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
