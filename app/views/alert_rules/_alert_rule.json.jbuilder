json.extract! alert_rule, :id, :name, :description, :target_entity_type, :condition, :severity, :notification_channels, :is_active, :created_at, :updated_at
json.url alert_rule_url(alert_rule, format: :json)
