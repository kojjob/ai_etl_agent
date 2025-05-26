json.extract! project, :id, :name, :description, :created_by_user_id, :status, :started_at, :due_at, :tags, :created_at, :updated_at
json.url project_url(project, format: :json)
