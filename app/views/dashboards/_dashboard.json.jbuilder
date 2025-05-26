json.extract! dashboard, :id, :user_id, :name, :description, :layout_config, :is_default, :is_shared, :shared_with_roles, :created_at, :updated_at
json.url dashboard_url(dashboard, format: :json)
