json.extract! system_setting, :id, :setting_key, :setting_value, :description, :is_sensitive, :created_at, :updated_at
json.url system_setting_url(system_setting, format: :json)
