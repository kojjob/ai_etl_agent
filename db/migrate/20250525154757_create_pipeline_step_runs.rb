class CreatePipelineStepRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :pipeline_step_runs do |t|
      t.references :pipeline_run, null: false, foreign_key: true
      t.references :pipeline_step, null: false, foreign_key: true
      t.string :status
      t.datetime :start_time
      t.datetime :end_time
      t.bigint :duration_ms
      t.jsonb :metrics
      t.text :logs_summary
      t.jsonb :input_data_preview
      t.jsonb :output_data_preview

      t.timestamps
    end
  end
end
