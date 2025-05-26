FactoryBot.define do
  factory :ai_interaction_log do
    user { nil }
    session_id { "" }
    user_query { "MyText" }
    ai_response { "MyText" }
    interaction_type { "MyString" }
    context_entity { nil }
  end
end
