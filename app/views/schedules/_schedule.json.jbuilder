json.extract! schedule, :id, :pipeline_id, :cron_expression, :timezone, :is_active, :next_run_at, :last_triggered_run_id, :created_by_user_id, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
