json.extract! run_log, :id, :pipeline_run_id, :pipeline_step_run_id, :timestamp, :level, :message, :source, :created_at, :updated_at
json.url run_log_url(run_log, format: :json)
