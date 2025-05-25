FactoryBot.define do
  factory :pipeline_step do
    pipeline { nil }
    name { "MyString" }
    description { "MyText" }
    step_type { "MyString" }
    sequence_order { 1 }
    configuration { "" }
    source_connection { nil }
    target_connection { nil }
    expected_input_schema { "" }
    expected_output_schema { "" }
    ui_position { "" }
  end
end
