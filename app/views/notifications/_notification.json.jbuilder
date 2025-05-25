json.extract! notification, :id, :user_id, :alert_id, :channel, :content, :status, :read_at, :created_at, :updated_at
json.url notification_url(notification, format: :json)
