FactoryBot.define do
  factory :pipeline_run do
    pipeline { nil }
    pipeline_version_at_run { 1 }
    status { "MyString" }
    triggered_by_type { "MyString" }
    triggered_by_user { nil }
    start_time { "2025-05-25 16:35:14" }
    end_time { "2025-05-25 16:35:14" }
    duration_ms { "" }
    parameters { "" }
    summary_metrics { "" }
  end
end
