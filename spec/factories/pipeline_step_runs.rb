FactoryBot.define do
  factory :pipeline_step_run do
    pipeline_run { nil }
    pipeline_step { nil }
    status { "MyString" }
    start_time { "2025-05-25 16:47:58" }
    end_time { "2025-05-25 16:47:58" }
    duration_ms { "" }
    metrics { "" }
    logs_summary { "MyText" }
    input_data_preview { "" }
    output_data_preview { "" }
  end
end
