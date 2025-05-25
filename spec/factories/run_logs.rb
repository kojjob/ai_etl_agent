FactoryBot.define do
  factory :run_log do
    pipeline_run { nil }
    pipeline_step_run { nil }
    timestamp { "2025-05-25 16:49:15" }
    level { "MyString" }
    message { "MyText" }
    source { "MyString" }
  end
end
