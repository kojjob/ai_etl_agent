json.extract! dashboard_widget, :id, :dashboard_id, :widget_type, :title, :configuration, :refresh_interval_seconds, :created_at, :updated_at
json.url dashboard_widget_url(dashboard_widget, format: :json)
