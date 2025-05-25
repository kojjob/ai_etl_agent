json.extract! pipeline_run, :id, :pipeline_id, :pipeline_version_at_run, :status, :triggered_by_type, :triggered_by_user_id, :start_time, :end_time, :duration_ms, :parameters, :summary_metrics, :created_at, :updated_at
json.url pipeline_run_url(pipeline_run, format: :json)
