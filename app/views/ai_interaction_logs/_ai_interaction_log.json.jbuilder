json.extract! ai_interaction_log, :id, :user_id, :session_id, :user_query, :ai_response, :interaction_type, :context_entity_id, :context_entity_type, :created_at, :updated_at
json.url ai_interaction_log_url(ai_interaction_log, format: :json)
