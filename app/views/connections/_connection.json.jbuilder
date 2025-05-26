json.extract! connection, :id, :name, :description, :type, :configuration, :test_status, :last_tested_at, :created_by_user_id, :created_at, :updated_at
json.url connection_url(connection, format: :json)
