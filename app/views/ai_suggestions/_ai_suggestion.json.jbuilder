json.extract! ai_suggestion, :id, :user_id, :session_id, :context_entity_id, :context_entity_type, :suggestion_prompt, :suggestion_content, :suggestion_type, :confidence_score, :status, :feedback_rating, :feedback_text, :created_at, :updated_at
json.url ai_suggestion_url(ai_suggestion, format: :json)
