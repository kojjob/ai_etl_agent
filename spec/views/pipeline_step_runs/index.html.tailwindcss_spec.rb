require 'rails_helper'

RSpec.describe "pipeline_step_runs/index", type: :view do
  before(:each) do
    assign(:pipeline_step_runs, [
      PipelineStepRun.create!(
        pipeline_run: nil,
        pipeline_step: nil,
        status: "Status",
        duration_ms: "",
        metrics: "",
        logs_summary: "MyText",
        input_data_preview: "",
        output_data_preview: ""
      ),
      PipelineStepRun.create!(
        pipeline_run: nil,
        pipeline_step: nil,
        status: "Status",
        duration_ms: "",
        metrics: "",
        logs_summary: "MyText",
        input_data_preview: "",
        output_data_preview: ""
      )
    ])
  end

  it "renders a list of pipeline_step_runs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
