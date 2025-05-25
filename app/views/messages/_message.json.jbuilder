json.extract! message, :id, :session_id, :role, :content, :data_attachment_path, :user_id, :created_at, :updated_at
json.url message_url(message, format: :json)
