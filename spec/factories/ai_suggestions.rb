FactoryBot.define do
  factory :ai_suggestion do
    user { nil }
    session_id { "" }
    context_entity { nil }
    suggestion_prompt { "MyText" }
    suggestion_content { "" }
    suggestion_type { "MyString" }
    confidence_score { 1.5 }
    status { "MyString" }
    feedback_rating { 1 }
    feedback_text { "MyText" }
  end
end
