json.extract! pipeline_step_run, :id, :pipeline_run_id, :pipeline_step_id, :status, :start_time, :end_time, :duration_ms, :metrics, :logs_summary, :input_data_preview, :output_data_preview, :created_at, :updated_at
json.url pipeline_step_run_url(pipeline_step_run, format: :json)
