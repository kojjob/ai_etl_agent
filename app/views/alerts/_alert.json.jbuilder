json.extract! alert, :id, :pipeline_id, :pipeline_run_id, :pipeline_step_run_id, :rule_id, :severity, :message, :status, :acknowledged_by_user_id, :acknowledged_at, :resolved_at, :created_at, :updated_at
json.url alert_url(alert, format: :json)
