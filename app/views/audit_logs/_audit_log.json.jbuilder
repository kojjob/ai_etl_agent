json.extract! audit_log, :id, :user_id, :action, :entity_id, :entity_type, :old_value, :new_value, :ip_address, :created_at, :updated_at
json.url audit_log_url(audit_log, format: :json)
