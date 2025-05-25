class CreatePipelineRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :pipeline_runs do |t|
      t.references :pipeline, null: false, foreign_key: true
      t.integer :pipeline_version_at_run
      t.string :status
      t.string :triggered_by_type
      t.references :triggered_by_user, null: false, foreign_key: { to_table: :users } 
      t.datetime :start_time
      t.datetime :end_time
      t.bigint :duration_ms
      t.jsonb :parameters
      t.jsonb :summary_metrics

      t.timestamps
    end
  end
end
