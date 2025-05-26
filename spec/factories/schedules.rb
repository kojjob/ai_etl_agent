FactoryBot.define do
  factory :schedule do
    pipeline { nil }
    cron_expression { "MyString" }
    timezone { "MyString" }
    is_active { false }
    next_run_at { "2025-05-25 16:31:43" }
    last_triggered_run { nil }
    created_by_user { nil }
  end
end
