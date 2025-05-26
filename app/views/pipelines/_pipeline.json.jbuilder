json.extract! pipeline, :id, :name, :description, :created_by_user_id, :project_id, :version, :status, :tags, :ai_assisted_design_details, :created_at, :updated_at
json.url pipeline_url(pipeline, format: :json)
