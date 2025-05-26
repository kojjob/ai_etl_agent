class AddForeignKeyToSchedulesLastTriggeredRun < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :schedules, :pipeline_runs, column: :last_triggered_run_id
  end
end
