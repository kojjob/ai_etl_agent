FactoryBot.define do
  factory :alert do
    pipeline { nil }
    pipeline_run { nil }
    pipeline_step_run { nil }
    rule { nil }
    severity { "MyString" }
    message { "MyText" }
    status { "MyString" }
    acknowledged_by_user { nil }
    acknowledged_at { "2025-05-25 18:54:50" }
    resolved_at { "2025-05-25 18:54:50" }
  end
end
