require 'rails_helper'

RSpec.describe "pipeline_runs/index", type: :view do
  before(:each) do
    assign(:pipeline_runs, [
      PipelineRun.create!(
        pipeline: nil,
        pipeline_version_at_run: 2,
        status: "Status",
        triggered_by_type: "Triggered By Type",
        triggered_by_user: nil,
        duration_ms: "",
        parameters: "",
        summary_metrics: ""
      ),
      PipelineRun.create!(
        pipeline: nil,
        pipeline_version_at_run: 2,
        status: "Status",
        triggered_by_type: "Triggered By Type",
        triggered_by_user: nil,
        duration_ms: "",
        parameters: "",
        summary_metrics: ""
      )
    ])
  end

  it "renders a list of pipeline_runs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Status".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Triggered By Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
